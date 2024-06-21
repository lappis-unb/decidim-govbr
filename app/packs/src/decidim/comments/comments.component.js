import Rails from "@rails/ujs";

// This is necessary for testing purposes
const $ = window.$;

import { createCharacterCounter } from "src/decidim/input_character_counter";
import ExternalLink from "src/decidim/external_link";
import updateExternalDomainLinks from "src/decidim/external_domain_warning";

export default class CommentsComponent {
  constructor($element, config) {
    this.$element = $element;
    this.commentableGid = config.commentableGid;
    this.commentsUrl = config.commentsUrl;
    this.rootDepth = config.rootDepth;
    this.order = config.order;
    this.lastCommentId = config.lastCommentId;
    this.pollingInterval = config.pollingInterval || 1500;
    this.singleComment = config.singleComment;
    this.toggleTranslations = config.toggleTranslations;
    this.id = this.$element.attr("id") || this._getUID();
    this.mounted = false;
    this.maxPages = Math.ceil(config.commentsCount / 10);
    this.currentPage = 1; 
    this.reordered = false;
    this.isLoading = false;
    this.isFetchingComments = false; 
    this.polledPages = new Set();
  }

  mountComponent() {
    if (this.$element.length > 0 && !this.mounted) {
      this.mounted = true;
      this._initializeComments(this.$element);
      if (!this.singleComment) {
        $(".add-comment textarea", this.$element).prop("disabled", true);
        this._fetchComments(() => {
          $(".add-comment textarea", this.$element).prop("disabled", false);
        });
      }

      $(".order-by__dropdown .is-submenu-item a", this.$element).on("click.decidim-comments", () => this._onInitOrder());

      this._initializeLoadMoreButton();
    }
  }

  unmountComponent() {
    if (this.mounted) {
      this.mounted = false;
      this._stopPolling();

      $(".add-comment .opinion-toggle .button", this.$element).off("click.decidim-comments");
      $(".add-comment textarea", this.$element).off("input.decidim-comments");
      $(".order-by__dropdown .is-submenu-item a", this.$element).off("click.decidim-comments");
      $(".add-comment form", this.$element).off("submit.decidim-comments");
      $(".add-comment textarea", this.$element).each((_i, el) => el.removeEventListener("emoji.added", this._onTextInput));

      const loadMoreButton = document.getElementById("load-more-comments");
      if (loadMoreButton) {
        loadMoreButton.removeEventListener("click", this._loadMoreHandler);
      }
    }
  }

  _initializeLoadMoreButton() {
    const loadMoreButton = document.getElementById("load-more-comments");
    if (loadMoreButton) {
      this._loadMoreHandler = (event) => {
        event.preventDefault();
        clearTimeout(this.debounceTimeout);
        this.debounceTimeout = setTimeout(() => {
          if (!this.isFetchingComments) {
            const page = parseInt(loadMoreButton.getAttribute("data-page"), 10);
            const newPage = page + 1;
            this._loadMoreComments(newPage);
          }
        }, 300);
      };

      loadMoreButton.addEventListener("click", this._loadMoreHandler);
    }
  }

  addThread(threadHtml, fromCurrentUser = false) {
    const $parent = $(".comments:first", this.$element);
    const $comment = $(threadHtml);
    const $threads = $(".comment-threads", this.$element);
    this._addComment($threads, $comment);
    this._finalizeCommentCreation($parent, fromCurrentUser);
  }

  _loadMoreComments(page) {
    if (!this.isFetchingComments && page <= this.maxPages && !this.polledPages.has(page)) {
      this.currentPage = page;
      this.isLoading = true;
      this._fetchComments(() => {
        const loadMoreButton = document.getElementById("load-more-comments");
        if (loadMoreButton) {
          loadMoreButton.setAttribute("data-page", this.currentPage);
        }
      }, page);
    }
  }

  addNewThread(threadHtml, fromCurrentUser = false) {
    const $parent = $(".comments:first", this.$element);
    const $comment = $(threadHtml);
    const $threads = $(".comment-threads", this.$element);
    this._addNewComment($threads, $comment);
    this._finalizeCommentCreation($parent, fromCurrentUser);
  }

  anchor() {
    setTimeout(() => {
      const $newComment = $("#comment_" + this.lastCommentId);
      if ($newComment.length) {
        const commentTop = $newComment.offset().top;
        const commentHeight = $newComment.height();
        $('html, body').animate({
          scrollTop: commentTop - commentHeight
        }, 150);
      } else {
        console.error("Comentario nao achado:", "comment_" + this.lastCommentId);
      }
    }, 180);
  }

  addReply(commentId, replyHtml, fromCurrentUser = false) {
    const $parent = $(`#comment_${commentId}`);
    const $comment = $(replyHtml);
    const $replies = $(`#comment-${commentId}-replies`);
    this._addComment($replies, $comment);
    $replies.siblings(".comment__additionalreply").removeClass("hide");
    this._finalizeCommentCreation($parent, fromCurrentUser);
  }

  _getUID() {
    return `comments-${new Date().setUTCMilliseconds()}-${Math.floor(Math.random() * 10000000)}`;
  }

  _initializeComments($parent) {
    $(".add-comment", $parent).each((_i, el) => {
      const $add = $(el);
      const $form = $("form", $add);
      const $opinionButtons = $(".opinion-toggle .button", $add);
      const $text = $("textarea", $form);

      $opinionButtons.on("click.decidim-comments", this._onToggleOpinion);
      $text.on("input.decidim-comments", this._onTextInput);

      $(document).trigger("attach-mentions-element", [$text.get(0)]);

      $form.on("submit.decidim-comments", () => {
        const $submit = $("button[type='submit']", $form);

        $submit.attr("disabled", "disabled");
        this._stopPolling();
      });

      if ($text.length && $text.get(0) !== null) {
        $text.get(0).addEventListener("emoji.added", this._onTextInput);
      }
    });
  }

  _addComment($target, $container) {
    let $comment = $(".comment", $container);
    if ($comment.length < 1) {
      $comment = $container;
    }
    this.lastCommentId = parseInt($comment.data("comment-id"), 10);

    $target.append($container);
    $container.foundation();
    this._initializeComments($container);
    createCharacterCounter($(".add-comment textarea", $container));
    $container.find('a[target="_blank"]').each((_i, elem) => {
      const $link = $(elem);
      $link.data("external-link", new ExternalLink($link));
    });
    updateExternalDomainLinks($container);
  }

  _addNewComment($target, $container) {
    let $comment = $(".comment", $container);
    if ($comment.length < 1) {
      $comment = $container;
    }
    this.lastCommentId = parseInt($comment.data("comment-id"), 10);

    $target.prepend($container);
    $container.foundation();
    this._initializeComments($container);
    createCharacterCounter($(".add-comment textarea", $container));
    $container.find('a[target="_blank"]').each((_i, elem) => {
      const $link = $(elem);
      $link.data("external-link", new ExternalLink($link));
    });
    updateExternalDomainLinks($container);
  }

  _finalizeCommentCreation($parent, fromCurrentUser) {
    if (fromCurrentUser) {
      const $add = $("> .add-comment", $parent);
      const $text = $("textarea", $add);
      const characterCounter = $text.data("remaining-characters-counter");
      $text.val("");
      if (characterCounter) {
        characterCounter.updateStatus();
      }
      if (!$add.parent().is(".comments")) {
        $add.addClass("hide");
      }
    }

    this._pollComments();
  }

  _pollComments(page = 1) {
    this._stopPolling();
    if (this.pollTimeout) {
      clearTimeout(this.pollTimeout);
    }
    this.pollTimeout = setTimeout(() => {
      if (!this.polledPages.has(page)) {
        this._fetchComments(() => {
          this.isLoading = false;
        }, page);
        this.polledPages.add(page); 
        this._stopPolling();
      }
    }, this.pollingInterval);
  }

  _fetchComments(successCallback = null, page = this.currentPage) {
    if (this.isFetchingComments) return; 

    this.isFetchingComments = true; 
    this.isLoading = true;

    Rails.ajax({
      url: this.commentsUrl,
      type: "GET",
      data: new URLSearchParams({
        "commentable_gid": this.commentableGid,
        "root_depth": this.rootDepth,
        "order": this.order,
        "after": this.lastCommentId,
        "page": page,
        ...(this.toggleTranslations && { "toggle_translations": this.toggleTranslations }),
      }),
      success: (data) => {
        const $commentsContainer = $(".comment-threads", this.$element);
        if (page === this.currentPage) {
          $commentsContainer.html(data.html); 
          this._initializeComments($commentsContainer);
        } else {
          $commentsContainer.append(data.html); 
          this._initializeComments($commentsContainer);
        }

        if (successCallback) {
          successCallback();
        }

        this.isLoading = false;
        this.isFetchingComments = false; 
        this._setLoading(false);
      },
      error: () => {
        this.isLoading = false;
        this.isFetchingComments = false; 
        this._setLoading(false);
      }
    });
  }

  _stopPolling() {
    if (this.pollTimeout) {
      clearTimeout(this.pollTimeout);
    }
  }

  _setLoading(isLoading) {
    const $container = $("> .comments-container", this.$element);
    const $comments = $("> .comments", $container);
    const $loading = $("> .loading-comments", $container);
    const loadMoreButton = document.getElementById("load-more-comments");

    if (isLoading) {
      $comments.addClass("hide");
      if (loadMoreButton) loadMoreButton.style.display = "none";
      $loading.removeClass("hide");
    } else {
      $comments.removeClass("hide");
      if (loadMoreButton) loadMoreButton.style.display = "block";
      $loading.addClass("hide");
    }
  }

  _onInitOrder() {
    this._stopPolling();
    this.reordered = true;
    this._setLoading(true);
    this.currentPage = 1; 
    this.polledPages.clear(); 
    this._fetchComments(() => {
      this.reordered = false;
      this._setLoading(false);
    }, 1); 
  }

  _onToggleOpinion(ev) {
    let $btn = $(ev.target);
    if (!$btn.is(".button")) {
      $btn = $btn.parents(".button");
    }

    const $add = $btn.closest(".add-comment");
    const $form = $("form", $add);
    const $opinionButtons = $(".opinion-toggle .button", $add);
    const $selectedState = $(".opinion-toggle .selected-state", $add);
    const $alignment = $(".alignment-input", $form);

    $opinionButtons.removeClass("is-active").attr("aria-pressed", "false");
    $btn.addClass("is-active").attr("aria-pressed", "true");

    if ($btn.is(".opinion-toggle--ok")) {
      $alignment.val(1);
    } else if ($btn.is(".opinion-toggle--meh")) {
      $alignment.val(0);
    } else if ($btn.is(".opinion-toggle--ko")) {
      $alignment.val(-1);
    }

    $selectedState.text($btn.data("selected-label"));
  }

  _onTextInput(ev) {
    const $text = $(ev.target);
    const $add = $text.closest(".add-comment");
    const $form = $("form", $add);
    const $submit = $("button[type='submit']", $form);

    if ($text.val().length > 0) {
      $submit.removeAttr("disabled");
    } else {
      $submit.attr("disabled", "disabled");
    }
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const loadMoreButton = document.getElementById("load-more-comments");
  const commentsComponent = new CommentsComponent($(".comments-container"), {
    commentableGid: loadMoreButton.getAttribute("data-commentable-gid"),
    commentsUrl: "/comments",
    order: loadMoreButton.getAttribute("data-order"),
    commentsCount: parseInt(loadMoreButton.getAttribute("data-comments-count"), 10)
  });

  if (loadMoreButton) {
    const loadMoreHandler = (event) => {
      const page = parseInt(loadMoreButton.getAttribute("data-page"), 10);
      const newPage = page + 1;
      commentsComponent._loadMoreComments(newPage);
    };

    loadMoreButton.addEventListener("click", loadMoreHandler);
  }

  commentsComponent.mountComponent();
});
