const acessibility_widget = (() => {
  "use strict";
  function t(t, e) {
    t.style.display =
      void 0 === e
        ? "none" === t.style.display
          ? "block"
          : "none"
        : 1 == e
        ? "block"
        : "none";
  }
  const e =
      '<style>.asw-menu{position:fixed;right:20px;top:20px;border-radius:8px;box-shadow:0 0 20px #00000080;opacity:1;transition:.3s;z-index:500000;overflow:hidden;background:#f9f9f9;width:500px;line-height:1;font-size:16px;height:calc(100% - 40px - 75px);letter-spacing:.015em}.asw-menu *{color:#000!important}.asw-menu svg{width:24px;height:24px;background:0 0!important;fill:currentColor}.asw-menu-header{display:flex;align-items:center;justify-content:space-between;padding-left:18px;height:60px;font-size:18px;font-weight:700;border-bottom:1px solid #dedede}.asw-menu-header>div{display:flex}.asw-menu-header div[role=button]{padding:12px;cursor:pointer}.asw-menu-header div[role=button]:hover{opacity:.8}.asw-card{margin:0 15px 15px}.asw-card-title{font-size:20px;padding:15px 0;font-weight:700;color:#555}.asw-menu .asw-select{width:100%!important;padding:10px!important;font-size:16px!important;font-family:inherit!important;font-weight:400!important;border-radius:4px!important;background:#fff!important;border:none!important;border:1px solid #dedede!important;color:inherit!important}.asw-items{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:1rem}.asw-btn{aspect-ratio:6/5;border-radius:4px;padding:0 15px;display:flex;align-items:center;justify-content:center;flex-direction:column;text-align:center;color:#333;font-size:16px!important;background:#fff;border:1px solid #dedede;transition:all .3s ease;cursor:pointer;line-height:1.4}.asw-btn .asw-translate{font-size:15px!important}.asw-btn svg{margin-bottom:16px}.asw-btn:hover{border-color:#0048ff}.asw-btn.asw-selected{background:#0048ff;border-color:#0048ff}.asw-adjust-font div[role=button] svg,.asw-btn.asw-selected *{fill:#fff!important;color:#fff!important;background-color:transparent!important}.asw-minus:hover,.asw-plus:hover{opacity:.8}.asw-menu-content{overflow:scroll;max-height:calc(100% - 40px);color:#333;padding:15px 0}.asw-adjust-font{background:#fff;border:1px solid #dedede;padding:20px;margin-bottom:16px}.asw-adjust-font .asw-label{display:flex;justify-content:flex-start}.asw-adjust-font>div{display:flex;justify-content:space-between;margin-top:20px;align-items:center;font-size:15px}.asw-adjust-font .asw-label div{font-size:15px!important}.asw-adjust-font div[role=button]{background:#0648ff;border-radius:50%;width:36px;height:36px;display:flex;align-items:center;justify-content:center;cursor:pointer}.asw-overlay{position:fixed;top:0;left:0;width:100%;height:100%;z-index:10000}@media only screen and (max-width:560px){.asw-menu{width:calc(100% - 20px);left:10px}}@media only screen and (max-width:420px){.asw-items{grid-template-columns:repeat(2,minmax(0,1fr));gap:.5rem}.asw-menu{width:calc(100% - 20px);left:10px}}</style> <div class="asw-menu"> <div class="asw-menu-header"> <div class="asw-translate">Accessibility Menu</div> <div> <div role="button" class="asw-menu-reset" title="Reset settings"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <path d="M12 4c2.1 0 4.1.8 5.6 2.3 3.1 3.1 3.1 8.2 0 11.3a7.78 7.78 0 0 1-6.7 2.3l.5-2c1.7.2 3.5-.4 4.8-1.7a6.1 6.1 0 0 0 0-8.5A6.07 6.07 0 0 0 12 6v4.6l-5-5 5-5V4M6.3 17.6C3.7 15 3.3 11 5.1 7.9l1.5 1.5c-1.1 2.2-.7 5 1.2 6.8.5.5 1.1.9 1.8 1.2l-.6 2a8 8 0 0 1-2.7-1.8Z"/> </svg> </div> <div role="button" class="asw-menu-close" title="Close"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <path d="M19 6.41 17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12 19 6.41Z"/> </svg> </div> </div> </div> <div class="asw-menu-content"> <div class="asw-card"> <div class="asw-card-title">Content Adjustments</div> <div class="asw-adjust-font"> <div class="asw-label" style="margin:0"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" style="margin-right:8px"> <path d="M2 4v3h5v12h3V7h5V4H2m19 5h-9v3h3v7h3v-7h3V9Z"/> </svg> <div class="asw-translate">Adjust Font Size</div> </div> <div> <div class="asw-minus" data-key="font-size" role="button" aria-pressed="false" title="Decrease Font Size"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <path d="M19 13H5v-2h14v2Z"/> </svg> </div> <div class="asw-amount" style="font-weight:400">100%</div> <div class="asw-plus" data-key="font-size" role="button" aria-pressed="false" title="Increase Font Size"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"> <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2Z"/> </svg> </div> </div> </div> <div class="asw-items content"></div> </div> <div class="asw-card"> <div class="asw-card-title">Color Adjustments</div> <div class="asw-items contrast"></div> </div> <div class="asw-card"> <div class="asw-card-title">Tools</div> <div class="asw-items tools"></div> </div> </div> </div> ',
    n = [
      {
        label: "Monochrome",
        key: "monochrome",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="m19 19-7-8v8H5l7-8V5h7m0-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2Z"/>\n</svg>',
      },
      {
        label: "High Contrast",
        key: "high-contrast",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24">\n  <path d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20zm-1 17.93a8 8 0 0 1 0-15.86v15.86zm2-15.86a8 8 0 0 1 2.87.93H13v-.93zM13 7h5.24c.25.31.48.65.68 1H13V7zm0 3h6.74c.08.33.15.66.19 1H13v-1zm0 9.93V19h2.87a8 8 0 0 1-2.87.93zM18.24 17H13v-1h5.92c-.2.35-.43.69-.68 1zm1.5-3H13v-1h6.93a8.4 8.4 0 0 1-.19 1z"/>\n</svg>',
      },
      {
        label: "Light Contrast",
        key: "light-contrast",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M12 18a6 6 0 0 1-6-6 6 6 0 0 1 6-6 6 6 0 0 1 6 6 6 6 0 0 1-6 6m8-2.69L23.31 12 20 8.69V4h-4.69L12 .69 8.69 4H4v4.69L.69 12 4 15.31V20h4.69L12 23.31 15.31 20H20v-4.69Z"/>\n</svg>',
      },
      {
        label: "Low Saturation",
        key: "low-saturation",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M11 9h2v2h-2V9m-2 2h2v2H9v-2m4 0h2v2h-2v-2m2-2h2v2h-2V9M7 9h2v2H7V9m12-6H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2M9 18H7v-2h2v2m4 0h-2v-2h2v2m4 0h-2v-2h2v2m2-7h-2v2h2v2h-2v-2h-2v2h-2v-2h-2v2H9v-2H7v2H5v-2h2v-2H5V5h14v6Z"/>\n</svg>',
      },
      {
        label: "High Saturation",
        key: "high-saturation",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M12 16a4 4 0 0 1-4-4 4 4 0 0 1 4-4 4 4 0 0 1 4 4 4 4 0 0 1-4 4m6.7-3.6a6.06 6.06 0 0 0-.86-.4 5.98 5.98 0 0 0 3.86-5.59 6 6 0 0 0-6.78.54A5.99 5.99 0 0 0 12 .81a6 6 0 0 0-2.92 6.14A6 6 0 0 0 2.3 6.4 5.95 5.95 0 0 0 6.16 12a6 6 0 0 0-3.86 5.58 6 6 0 0 0 6.78-.54A6 6 0 0 0 12 23.19a6 6 0 0 0 2.92-6.14 6 6 0 0 0 6.78.54 5.98 5.98 0 0 0-3-5.19Z"/>\n</svg>',
      },
    ];
  function i(t, e) {
    for (var n = "", i = t.length; i--; ) {
      var a = t[i];
      n += '\n            <button class="asw-btn '
        .concat(e || "", '" type="button" data-key="')
        .concat(a.key, '" title="')
        .concat(a.label, '">\n                ')
        .concat(a.icon, '\n                <span class="asw-translate">')
        .concat(a.label, "</span>\n            </button>\n        ");
    }
    return n;
  }
  function a(t) {
    void 0 === t && (t = 1),
      document
        .querySelectorAll(
          "h1,h2,h3,h4,h5,h6,p,a,dl,dt,li,ol,th,td,span,blockquote,.asw-text"
        )
        .forEach(function (e) {
          var n;
          if (
            !e.classList.contains("material-icons") &&
            !e.classList.contains("fa")
          ) {
            var i = Number(
              null !== (n = e.getAttribute("data-asw-orgFontSize")) &&
                void 0 !== n
                ? n
                : 0
            );
            i ||
              ((i = parseInt(
                window.getComputedStyle(e).getPropertyValue("font-size")
              )),
              e.setAttribute("data-asw-orgFontSize", String(i)));
            var a = i * t;
            e.style["font-size"] = a + "px";
          }
        });
    var e = document.querySelector(".asw-amount");
    e && (e.innerText = "".concat((100 * t).toFixed(0), "%"));
  }
  function o(t) {
    var e = t.id,
      n = t.css;
    if (n) {
      var i =
        document.getElementById(e || "") || document.createElement("style");
      (i.innerHTML = n), i.id || ((i.id = e), document.head.appendChild(i));
    }
  }
  var s = ["-o-", "-ms-", "-moz-", "-webkit-", ""],
    r = ["filter"];
  function l(t) {
    var e,
      n = "";
    return (
      t &&
        ((n += null !== (e = t.css) && void 0 !== e ? e : ""),
        (n += (function (t) {
          var e = "";
          if (t) {
            var n = function (n) {
              (r.includes(n) ? s : [""]).forEach(function (i) {
                e += "".concat(i).concat(n, ":").concat(t[n], " !important;");
              });
            };
            for (var i in t) n(i);
          }
          return e;
        })(t.styles)).length &&
          t.selector &&
          (n = (function (t) {
            var e = t.selector,
              n = t.childrenSelector,
              i = t.css,
              a = "";
            return (
              (void 0 === n ? [""] : n).forEach(function (t) {
                a += "".concat(e, " ").concat(t, "{").concat(i, "}");
              }),
              a
            );
          })({
            selector: t.selector,
            childrenSelector: t.childrenSelector,
            css: n,
          }))),
      n
    );
  }
  function c(t) {
    var e,
      n = t.id,
      i = void 0 === n ? "" : n,
      a = t.enable,
      s = void 0 !== a && a,
      r = "asw-".concat(i);
    s
      ? o({ css: l(t), id: r })
      : null === (e = document.getElementById(r)) || void 0 === e || e.remove(),
      document.documentElement.classList.toggle(r, s);
  }
  var d = function () {
      return (
        (d =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        d.apply(this, arguments)
      );
    },
    u = {
      id: "stop-animations",
      selector: "html",
      childrenSelector: ["*"],
      styles: {
        transition: "none",
        "animation-fill-mode": "forwards",
        "animation-iteration-count": "1",
        "animation-duration": ".01s",
      },
    },
    g = function (t, e, n) {
      if (n || 2 === arguments.length)
        for (var i, a = 0, o = e.length; a < o; a++)
          (!i && a in e) ||
            (i || (i = Array.prototype.slice.call(e, 0, a)), (i[a] = e[a]));
      return t.concat(i || Array.prototype.slice.call(e));
    },
    h = ["", "*:not(.material-icons,.asw-menu,.asw-menu *)"],
    p = [
      "h1",
      "h2",
      "h3",
      "h4",
      "h5",
      "h6",
      ".wsite-headline",
      ".wsite-content-title",
      "div",
    ],
    m = g(
      g([], p, !0),
      [
        "img",
        "p",
        "i",
        "svg",
        "a",
        "button:not(.asw-btn)",
        "label",
        "li",
        "ol",
        "div",
        "section",
        "footer",
        "header",
      ],
      !1
    ),
    v = function () {
      return (
        (v =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        v.apply(this, arguments)
      );
    },
    w = {
      id: "readable-font",
      selector: "html",
      childrenSelector: (function (t, e, n) {
        if (n || 2 === arguments.length)
          for (var i, a = 0, o = e.length; a < o; a++)
            (!i && a in e) ||
              (i || (i = Array.prototype.slice.call(e, 0, a)), (i[a] = e[a]));
        return t.concat(i || Array.prototype.slice.call(e));
      })(["", "*:not(.material-icons,.fa)"], m, !0),
      styles: {
        "font-family": "OpenDyslexic3,Comic Sans MS,Arial,Helvetica,sans-serif",
      },
      css: '\n        @font-face {\n            font-family: OpenDyslexic3;\n            src: url("https://website-widgets.pages.dev/fonts/OpenDyslexic3-Regular.woff") format("woff"), url("https://website-widgets.pages.dev/fonts/OpenDyslexic3-Regular.ttf") format("truetype");\n        }\n    ',
    },
    f = function () {
      return (
        (f =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        f.apply(this, arguments)
      );
    },
    S = { lang: "pt", states: { fontSize: 1 }, updatedAt: new Date() },
    b = S,
    y = "asw";
  function x(t) {
    var e = f(f({}, b), {
      states: f(f({}, b.states), t),
      updatedAt: new Date(),
    });
    return C(e), e;
  }
  function C(t) {
    (b = f(f({}, b), t)),
      (function (t, e, n) {
        var i = new Date();
        i.setTime(i.getTime() + NaN);
        var a = "expires=" + i.toUTCString();
        document.cookie = t + "=" + e + ";" + a + ";path=/";
      })(y, JSON.stringify(b));
  }
  function A(t) {
    return b.states[t];
  }
  function L(t) {
    if ((void 0 === t && (t = !0), t)) return b;
    var e = F();
    return (b = e ? JSON.parse(e) : S);
  }
  function F() {
    return (function (t) {
      for (
        var e = t + "=",
          n = decodeURIComponent(document.cookie).split(";"),
          i = 0;
        i < n.length;
        i++
      ) {
        for (var a = n[i]; " " == a.charAt(0); ) a = a.substring(1);
        if (0 == a.indexOf(e)) return a.substring(e.length, a.length);
      }
      return "";
    })(y);
  }
  var H = function () {
      return (
        (H =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        H.apply(this, arguments)
      );
    },
    k = {
      id: "big-cursor",
      selector: "body",
      childrenSelector: ["*"],
      styles: {
        cursor:
          "url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='98px' viewBox='0 0 48 48'%3E%3Cpath fill='%23E0E0E0' d='M27.8 39.7c-.1 0-.2 0-.4-.1s-.4-.3-.6-.5l-3.7-8.6-4.5 4.2c-.1.2-.3.3-.6.3-.1 0-.3 0-.4-.1-.3-.1-.6-.5-.6-.9V12c0-.4.2-.8.6-.9.1-.1.3-.1.4-.1.2 0 .5.1.7.3l16 15c.3.3.4.7.3 1.1-.1.4-.5.6-.9.7l-6.3.6 3.9 8.5c.1.2.1.5 0 .8-.1.2-.3.5-.5.6l-2.9 1.3c-.2-.2-.4-.2-.5-.2z'/%3E%3Cpath fill='%23212121' d='m18 12 16 15-7.7.7 4.5 9.8-2.9 1.3-4.3-9.9L18 34V12m0-2c-.3 0-.5.1-.8.2-.7.3-1.2 1-1.2 1.8v22c0 .8.5 1.5 1.2 1.8.3.2.6.2.8.2.5 0 1-.2 1.4-.5l3.4-3.2 3.1 7.3c.2.5.6.9 1.1 1.1.2.1.5.1.7.1.3 0 .5-.1.8-.2l2.9-1.3c.5-.2.9-.6 1.1-1.1.2-.5.2-1.1 0-1.5l-3.3-7.2 4.9-.4c.8-.1 1.5-.6 1.7-1.3.3-.7.1-1.6-.5-2.1l-16-15c-.3-.5-.8-.7-1.3-.7z'/%3E%3C/svg%3E\"),default",
      },
    },
    z = function () {
      return (
        (z =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        z.apply(this, arguments)
      );
    },
    j = {
      id: "highlight-title",
      selector: "html",
      childrenSelector: p,
      styles: { outline: "2px solid #0048ff", "outline-offset": "2px" },
    };
  const M =
    '<style>.asw-rg{position:fixed;top:0;left:0;right:0;width:100%;height:0;pointer-events:none;background-color:rgba(0,0,0,.5);z-index:1000000}</style> <div class="asw-rg asw-rg-top"></div> <div class="asw-rg asw-rg-bottom" style="top:auto;bottom:0"></div>';
  var R = function () {
      return (
        (R =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        R.apply(this, arguments)
      );
    },
    D = {
      id: "highlight-links",
      selector: "html",
      childrenSelector: ["a[href]"],
      styles: { outline: "2px solid #0048ff", "outline-offset": "2px" },
    },
    T = function () {
      return (
        (T =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        T.apply(this, arguments)
      );
    },
    O = {
      id: "letter-spacing",
      selector: "html",
      childrenSelector: h,
      styles: { "letter-spacing": "2px" },
    },
    B = function () {
      return (
        (B =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        B.apply(this, arguments)
      );
    },
    E = {
      id: "line-height",
      selector: "html",
      childrenSelector: h,
      styles: { "line-height": "3" },
    },
    _ = function () {
      return (
        (_ =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        _.apply(this, arguments)
      );
    },
    G = {
      id: "font-weight",
      selector: "html",
      childrenSelector: h,
      styles: { "font-weight": "700" },
    },
    N = [
      "B",
      "STRONG",
      "I",
      "U",
      "EM",
      "MARK",
      "SUB",
      "SUP",
      "INS",
      "PRE",
      "ABBR",
    ];
  function P() {
    var t,
      e = L().states;
    void 0 === (t = e["highlight-title"]) && (t = !1),
      c(z(z({}, j), { enable: t })),
      (function (t) {
        void 0 === t && (t = !1), c(R(R({}, D), { enable: t }));
      })(e["highlight-links"]),
      (function (t) {
        void 0 === t && (t = !1), c(T(T({}, O), { enable: t }));
      })(e["letter-spacing"]),
      (function (t) {
        void 0 === t && (t = !1), c(B(B({}, E), { enable: t }));
      })(e["line-height"]),
      (function (t) {
        void 0 === t && (t = !1), c(_(_({}, G), { enable: t }));
      })(e["font-weight"]),
      (function (t) {
        void 0 === t && (t = !1), c(v(v({}, w), { enable: t }));
      })(e["readable-font"]),
      (function (t) {
        void 0 === t && (t = !1);
        var e = document.querySelector(".asw-rg-container");
        if (t) {
          if (!e) {
            (e = document.createElement("div")).setAttribute(
              "class",
              "asw-rg-container"
            ),
              (e.innerHTML = M);
            var n = e.querySelector(".asw-rg-top"),
              i = e.querySelector(".asw-rg-bottom");
            (window.__asw__onScrollReadableGuide = function (t) {
              (n.style.height = t.clientY - 20 + "px"),
                (i.style.height = window.innerHeight - t.clientY - 40 + "px");
            }),
              document.addEventListener(
                "mousemove",
                window.__asw__onScrollReadableGuide,
                { passive: !1 }
              ),
              document.body.appendChild(e);
          }
        } else
          e && e.remove(),
            window.__asw__onScrollReadableGuide &&
              (document.removeEventListener(
                "mousemove",
                window.__asw__onScrollReadableGuide
              ),
              delete window.__asw__onScrollReadableGuide);
      })(e["readable-guide"]),
      (function (t) {
        void 0 === t && (t = !1), c(d(d({}, u), { enable: t }));
      })(e["stop-animations"]),
      (function (t) {
        void 0 === t && (t = !1), c(H(H({}, k), { enable: t }));
      })(e["big-cursor"]),
      (function (t) {
        void 0 === t && (t = !1),
          t
            ? ((window.__asw__onClickScreenReader = function (t) {
                var e,
                  n = t.target;
                ["BODY", "HEAD", "HTML"].includes(n.nodeName) ||
                  ((e = (function (t) {
                    var e, n, i;
                    if (!t) return "";
                    for (
                      var a = "", o = t.previousSibling, s = t.nextSibling;
                      o;

                    )
                      (o.nodeType === Node.TEXT_NODE ||
                        N.includes(o.nodeName)) &&
                        (r =
                          null === (e = o.textContent) || void 0 === e
                            ? void 0
                            : e.trim().replace(/[ \n]+/g, " ")) &&
                        (a = r + " " + a),
                        (o = o.previousSibling);
                    for (
                      a +=
                        (null === (n = t.textContent) || void 0 === n
                          ? void 0
                          : n.trim().replace(/[ \n]+/g, " ")) || "";
                      s;

                    ) {
                      var r;
                      (s.nodeType === Node.TEXT_NODE ||
                        N.includes(s.nodeName)) &&
                        (r =
                          null === (i = s.textContent) || void 0 === i
                            ? void 0
                            : i.trim().replace(/[ \n]+/g, " ")) &&
                        (a += " " + r),
                        (s = s.nextSibling);
                    }
                    return a.trim();
                  })(n)),
                  "speechSynthesis" in window &&
                  "SpeechSynthesisUtterance" in window
                    ? (speechSynthesis.speaking && speechSynthesis.cancel(),
                      console.log("speak:", e),
                      e &&
                        speechSynthesis.speak(new SpeechSynthesisUtterance(e)))
                    : console.log(
                        "Text-to-speech not supported in this browser."
                      ));
              }),
              document.addEventListener(
                "click",
                window.__asw__onClickScreenReader
              ))
            : window.__asw__onClickScreenReader &&
              (document.removeEventListener(
                "click",
                window.__asw__onClickScreenReader
              ),
              delete window.__asw__onClickScreenReader);
      })(e["highlight-title"]);
  }
  var V = {
      "dark-contrast": {
        styles: { color: "#FFF", fill: "#FFF", "background-color": "#000" },
        childrenSelector: m,
      },
      "light-contrast": {
        styles: { color: "#000", fill: "#000", "background-color": "#FFF" },
        childrenSelector: m,
      },
      "high-contrast": { styles: { filter: "contrast(125%)" } },
      "high-saturation": { styles: { filter: "saturate(200%)" } },
      "low-saturation": { styles: { filter: "saturate(50%)" } },
      monochrome: { styles: { filter: "grayscale(100%)" } },
    },
    I = function () {
      return (
        (I =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        I.apply(this, arguments)
      );
    };
  function J() {
    var t = L().states.contrast,
      e = "",
      n = V[t];
    n && (e = l(I(I({}, n), { selector: "html.aws-filter" }))),
      o({ css: e, id: "asw-filter-style" }),
      document.documentElement.classList.toggle("aws-filter", Boolean(t));
  }
  function W() {
    a(L().states.fontSize), P(), J();
  }
  const q = JSON.parse(
      '{"Accessibility Menu":"Accessibility menu","Reset settings":"Reset settings","Close":"Close","Content Adjustments":"Content Adjustments","Adjust Font Size":"Adjust Font Size","Highlight Title":"Highlight Title","Highlight Links":"Highlight Links","Readable Font":"Readable Font","Color Adjustments":"Color Adjustments","Dark Contrast":"Dark Contrast","Light Contrast":"Light Contrast","High Contrast":"High Contrast","High Saturation":"High Saturation","Low Saturation":"Low Saturation","Monochrome":"Monochrome","Tools":"Tools","Reading Guide":"Reading Guide","Stop Animations":"Stop Animations","Big Cursor":"Big Cursor","Increase Font Size":"Increase Font Size","Decrease Font Size":"Decrease Font Size","Letter Spacing":"Letter Spacing","Line Height":"Line Height","Font Weight":"Font Weight","Dyslexia Font":"Dyslexia Font","Language":"Language"}'
    ),
    K = JSON.parse(
      '{"Accessibility Menu":"Menú de accesibilidad","Reset settings":"Restablecer configuración","Close":"Cerrar","Content Adjustments":"Ajustes de contenido","Adjust Font Size":"Ajustar el tamaño de fuente","Highlight Title":"Destacar título","Highlight Links":"Destacar enlaces","Readable Font":"Fuente legible","Color Adjustments":"Ajustes de color","Dark Contrast":"Contraste oscuro","Light Contrast":"Contraste claro","High Contrast":"Alto contraste","High Saturation":"Alta saturación","Low Saturation":"Baja saturación","Monochrome":"Monocromo","Tools":"Herramientas","Reading Guide":"Guía de lectura","Stop Animations":"Detener animaciones","Big Cursor":"Cursor grande","Increase Font Size":"Aumentar tamaño de fuente","Decrease Font Size":"Reducir tamaño de fuente","Letter Spacing":"Espaciado entre letras","Line Height":"Altura de línea","Font Weight":"Grosor de fuente","Dyslexia Font":"Fuente para dislexia","Language":"Idioma"}'
    ),
    Z = JSON.parse(
      '{"Accessibility Menu":"قائمة إمكانية الوصول","Reset settings":"إعادة تعيين الإعدادات","Close":"إغلاق","Content Adjustments":"تعديلات المحتوى","Adjust Font Size":"تعديل حجم الخط","Highlight Title":"تسليط الضوء على العنوان","Highlight Links":"تسليط الضوء على الروابط","Readable Font":"خط سهل القراءة","Color Adjustments":"تعديلات الألوان","Dark Contrast":"تباين داكن","Light Contrast":"تباين فاتح","High Contrast":"تباين عالي","High Saturation":"تشبع عالي","Low Saturation":"تشبع منخفض","Monochrome":"أحادي اللون","Tools":"أدوات","Reading Guide":"دليل القراءة","Stop Animations":"إيقاف الرسوم المتحركة","Big Cursor":"مؤشر كبير","Increase Font Size":"زيادة حجم الخط","Decrease Font Size":"تقليل حجم الخط","Letter Spacing":"تباعد الحروف","Line Height":"ارتفاع السطر","Font Weight":"سماكة الخط","Dyslexia Font":"خط القراءة لمن يعانون من عسر القراءة","Language":"اللغة"}'
    ),
    U = JSON.parse(
      '{"Accessibility Menu":"Barrierefreiheit","Reset settings":"Einstellungen zurücksetzen","Close":"Schließen","Content Adjustments":"Inhaltsanpassungen","Adjust Font Size":"Schriftgröße anpassen","Highlight Title":"Titel hervorheben","Highlight Links":"Links hervorheben","Readable Font":"Lesbare Schrift","Color Adjustments":"Farbanpassungen","Dark Contrast":"Dunkler Kontrast","Light Contrast":"Heller Kontrast","High Contrast":"Hoher Kontrast","High Saturation":"Hohe Farbsättigung","Low Saturation":"Niedrige Farbsättigung","Monochrome":"Monochrom","Tools":"Werkzeuge","Reading Guide":"Leseanleitung","Stop Animations":"Animationen stoppen","Big Cursor":"Großer Cursor","Increase Font Size":"Schriftgröße vergrößern","Decrease Font Size":"Schriftgröße verkleinern","Letter Spacing":"Zeilenabstand","Line Height":"Zeilenhöhe","Font Weight":"Schriftstärke","Dyslexia Font":"Dyslexie-Schrift","Language":"Sprache"}'
    ),
    Y = JSON.parse(
      '{"Accessibility Menu":"पहुँचियोग्यता मेनू","Reset settings":"सेटिंग रीसेट करें","Close":"बंद करें","Content Adjustments":"सामग्री समायोजन","Adjust Font Size":"फ़ॉन्ट आकार समायोजित करें","Highlight Title":"शीर्षक को हाइलाइट करें","Highlight Links":"लिंक को हाइलाइट करें","Readable Font":"पढ़ने योग्य फ़ॉन्ट","Color Adjustments":"रंग समायोजन","Dark Contrast":"अंधेरा विरोध","Light Contrast":"प्रकाश विरोध","High Contrast":"उच्च विरोध","High Saturation":"उच्च संतुलन","Low Saturation":"निम्न संतुलन","Monochrome":"एकरंग","Tools":"उपकरण","Reading Guide":"पढ़ने का गाइड","Stop Animations":"एनिमेशन रोकें","Big Cursor":"बड़ा कर्सर","Increase Font Size":"फ़ॉन्ट आकार बढ़ाएँ","Decrease Font Size":"फ़ॉन्ट आकार कम करें","Letter Spacing":"अक्षर स्पेसिंग","Line Height":"लाइन की ऊँचाई","Font Weight":"फ़ॉन्ट वेट","Dyslexia Font":"विविधताजनित विपथता फ़ॉन्ट","Language":"भाषा"}'
    ),
    X = JSON.parse(
      '{"Accessibility Menu":"접근성 메뉴","Reset settings":"설정 초기화","Close":"닫기","Content Adjustments":"컨텐츠 조정","Adjust Font Size":"글꼴 크기 조정","Highlight Title":"제목 강조","Highlight Links":"링크 강조","Readable Font":"읽기 쉬운 글꼴","Color Adjustments":"색상 조정","Dark Contrast":"어두운 대비","Light Contrast":"밝은 대비","High Contrast":"높은 대비","High Saturation":"높은 채도","Low Saturation":"낮은 채도","Monochrome":"단색","Tools":"도구","Reading Guide":"읽기 가이드","Stop Animations":"애니메이션 중지","Big Cursor":"큰 커서","Increase Font Size":"글꼴 크기 증가","Decrease Font Size":"글꼴 크기 감소","Letter Spacing":"자간","Line Height":"줄 간격","Font Weight":"글꼴 두께","Dyslexia Font":"난독증 글꼴","Language":"언어"}'
    ),
    Q = JSON.parse(
      '{"Accessibility Menu":"アクセシビリティメニュー","Reset settings":"設定をリセット","Close":"閉じる","Content Adjustments":"コンテンツ調整","Adjust Font Size":"フォントサイズを調整","Highlight Title":"タイトルを強調表示","Highlight Links":"リンクを強調表示","Readable Font":"読みやすいフォント","Color Adjustments":"色の調整","Dark Contrast":"ダークコントラスト","Light Contrast":"ライトコントラスト","High Contrast":"高いコントラスト","High Saturation":"彩度が高い","Low Saturation":"彩度が低い","Monochrome":"モノクローム","Tools":"ツール","Reading Guide":"読み上げガイド","Stop Animations":"アニメーションを停止","Big Cursor":"大きなカーソル","Increase Font Size":"フォントサイズを大きくする","Decrease Font Size":"フォントサイズを小さくする","Letter Spacing":"文字間隔","Line Height":"行の高さ","Font Weight":"フォントの太さ","Dyslexia Font":"ディスレクシア用フォント","Language":"言語"}'
    ),
    $ = JSON.parse(
      '{"Accessibility Menu":"Menu d\'accessibilité","Reset settings":"Réinitialiser les paramètres","Close":"Fermer","Content Adjustments":"Ajustements de contenu","Adjust Font Size":"Ajuster la taille de police","Highlight Title":"Surligner le titre","Highlight Links":"Surligner les liens","Readable Font":"Police lisible","Color Adjustments":"Ajustements de couleur","Dark Contrast":"Contraste foncé","Light Contrast":"Contraste clair","High Contrast":"Contraste élevé","High Saturation":"Saturation élevée","Low Saturation":"Saturation faible","Monochrome":"Monochrome","Tools":"Outils","Reading Guide":"Guide de lecture","Stop Animations":"Arrêter les animations","Big Cursor":"Gros curseur","Increase Font Size":"Augmenter la taille de police","Decrease Font Size":"Réduire la taille de police","Letter Spacing":"Espacement des lettres","Line Height":"Hauteur de ligne","Font Weight":"Poids de la police","Dyslexia Font":"Police dyslexie","Language":"Langue"}'
    ),
    tt = JSON.parse(
      '{"Accessibility Menu":"Menu di accessibilità","Reset settings":"Ripristina impostazioni","Close":"Chiudi","Content Adjustments":"Regolazioni del contenuto","Adjust Font Size":"Regola la dimensione del carattere","Highlight Title":"Evidenzia il titolo","Highlight Links":"Evidenzia i collegamenti","Readable Font":"Carattere leggibile","Color Adjustments":"Regolazioni del colore","Dark Contrast":"Contrasto scuro","Light Contrast":"Contrasto chiaro","High Contrast":"Alto contrasto","High Saturation":"Alta saturazione","Low Saturation":"Bassa saturazione","Monochrome":"Monocromatico","Tools":"Strumenti","Reading Guide":"Guida alla lettura","Stop Animations":"Arresta le animazioni","Big Cursor":"Cursore grande","Increase Font Size":"Aumenta la dimensione del carattere","Decrease Font Size":"Diminuisci la dimensione del carattere","Letter Spacing":"Spaziatura delle lettere","Line Height":"Altezza della linea","Font Weight":"Peso del carattere","Dyslexia Font":"Carattere per dislessia","Language":"Lingua"}'
    ),
    et = JSON.parse(
      '{"Accessibility Menu":"Menu Aksesibilitas","Reset settings":"Atur Ulang Pengaturan","Close":"Tutup","Content Adjustments":"Penyesuaian Konten","Adjust Font Size":"Sesuaikan Ukuran Font","Highlight Title":"Sorot Judul","Highlight Links":"Sorot Tautan","Readable Font":"Font Mudah Dibaca","Color Adjustments":"Penyesuaian Warna","Dark Contrast":"Kontras Gelap","Light Contrast":"Kontras Terang","High Contrast":"Kontras Tinggi","High Saturation":"Saturasi Tinggi","Low Saturation":"Saturasi Rendah","Monochrome":"Monokrom","Tools":"Alat","Reading Guide":"Panduan Membaca","Stop Animations":"Hentikan Animasi","Big Cursor":"Kursor Besar","Increase Font Size":"Perbesar Ukuran Font","Decrease Font Size":"Perkecil Ukuran Font","Letter Spacing":"Jarak Huruf","Line Height":"Tinggi Baris","Font Weight":"Ketebalan Font","Dyslexia Font":"Font Disleksia","Language":"Bahasa"}'
    ),
    nt = JSON.parse(
      '{"Accessibility Menu":"Menu de Acessibilidade","Reset settings":"Redefinir configurações","Close":"Fechar","Content Adjustments":"Ajustes de Conteúdo","Adjust Font Size":"Ajustar Tamanho da Fonte","Highlight Title":"Destacar Título","Highlight Links":"Destacar Links","Readable Font":"Fonte Legível","Color Adjustments":"Ajustes de Cor","Dark Contrast":"Contraste Escuro","Light Contrast":"Contraste Claro","High Contrast":"Alto Contraste","High Saturation":"Saturação Alta","Low Saturation":"Saturação Baixa","Monochrome":"Monocromático","Tools":"Ferramentas","Reading Guide":"Guia de Leitura","Stop Animations":"Parar Animações","Big Cursor":"Cursor Grande","Increase Font Size":"Aumentar Tamanho da Fonte","Decrease Font Size":"Diminuir Tamanho da Fonte","Letter Spacing":"Espaçamento entre Letras","Line Height":"Altura da Linha","Font Weight":"Espessura da Fonte","Dyslexia Font":"Fonte para Dislexia","Language":"Idioma"}'
    ),
    it = JSON.parse(
      '{"Accessibility Menu":"תפריט נגישות","Reset settings":"איפוס הגדרות","Close":"סגור","Content Adjustments":"התאמות תוכן","Adjust Font Size":"התאם גודל פונט","Highlight Title":"הדגש כותרת","Highlight Links":"הדגש קישורים","Readable Font":"פונט קריא","Color Adjustments":"התאמות צבע","Dark Contrast":"ניגודיות כהה","Light Contrast":"ניגודיות בהירה","High Contrast":"ניגודיות גבוהה","High Saturation":"רווי צבע גבוה","Low Saturation":"רווי צבע נמוך","Monochrome":"מונוכרום","Tools":"כלים","Reading Guide":"מדריך קריאה","Stop Animations":"עצירת אנימציות","Big Cursor":"סמן גדול","Increase Font Size":"הגדל גודל פונט","Decrease Font Size":"הקטן גודל פונט","Letter Spacing":"מרווח בין אותיות","Line Height":"גובה שורה","Font Weight":"משקל הפונט","Dyslexia Font":"פונט לדיסלקטים","Language":"שפה"}'
    ),
    at = JSON.parse(
      '{"Accessibility Menu":"Meniu de accesibilitate","Reset settings":"Resetează setările","Close":"Închide","Content Adjustments":"Ajustări conținut","Adjust Font Size":"Ajustează dimensiunea fontului","Highlight Title":"Evidențiază titlul","Highlight Links":"Evidențiază legăturile","Readable Font":"Font lizibil","Color Adjustments":"Ajustări de culoare","Dark Contrast":"Contrast întunecat","Light Contrast":"Contrast luminos","High Contrast":"Contrast ridicat","High Saturation":"Saturație ridicată","Low Saturation":"Saturație redusă","Monochrome":"Monocrom","Tools":"Instrumente","Reading Guide":"Ghid de lectură","Stop Animations":"Opriți animațiile","Big Cursor":"Cursor mare","Increase Font Size":"Mărește dimensiunea fontului","Decrease Font Size":"Micșorează dimensiunea fontului","Letter Spacing":"Spațierea literelor","Line Height":"Înălțimea liniei","Font Weight":"Grosimea fontului","Dyslexia Font":"Font pentru dislexie","Language":"Limbă"}'
    ),
    ot = JSON.parse(
      '{"Accessibility Menu":"Menu Aksesibiliti","Reset settings":"Tetapkan semula tetapan","Close":"Tutup","Content Adjustments":"Penyesuaian Kandungan","Adjust Font Size":"Laraskan Saiz Fon","Highlight Title":"Serlahkan Tajuk","Highlight Links":"Serlahkan Pautan","Readable Font":"Fon Mudah Baca","Color Adjustments":"Penyesuaian Warna","Dark Contrast":"Kontras Gelap","Light Contrast":"Kontras Terang","High Contrast":"Kontras Tinggi","High Saturation":"Saturasi Tinggi","Low Saturation":"Saturasi Rendah","Monochrome":"Monokrom","Tools":"Peralatan","Reading Guide":"Panduan Membaca","Stop Animations":"Hentikan Animasi","Big Cursor":"Kursor Besar","Increase Font Size":"Besarkan Saiz Fon","Decrease Font Size":"Kecilkan Saiz Fon","Letter Spacing":"Ruangan Huruf","Line Height":"Ketinggian Garis","Font Weight":"Ketebalan Fon","Dyslexia Font":"Fon Dyslexia","Language":"Bahasa"}'
    );
  var st = {
    ar: Z,
    de: U,
    en: q,
    el: JSON.parse(
      '{"Accessibility Menu":"Μενού προσβασιμότητας","Reset settings":"Επαναφορά ρυθμίσεων","Close":"Κλείσιμο","Content Adjustments":"Προσαρμογές περιεχομένου","Adjust Font Size":"Προσαρμογή μεγέθους γραμματοσειράς","Highlight Title":"Επισήμανση τίτλου","Highlight Links":"Επισήμανση συνδέσμων","Readable Font":"Ευανάγνωστη γραμματοσειρά","Color Adjustments":"Προσαρμογές χρωμάτων","Dark Contrast":"Αντίθεση σε σκούρο","Light Contrast":"Αντίθεση σε φωτεινό","High Contrast":"Υψηλή αντίθεση","High Saturation":"Υψηλός κορεσμός","Low Saturation":"Χαμηλός κορεσμός","Monochrome":"Μονόχρωμο","Tools":"Εργαλεία","Reading Guide":"Οδηγός ανάγνωσης","Stop Animations":"Αφαίρεση κίνησης","Big Cursor":"Μεγάλος δείκτης","Increase Font Size":"Αύξηση μεγέθους γραμματοσειράς","Decrease Font Size":"Μείωση μεγέθους γραμματοσειράς","Letter Spacing":"Διάκενο γραμμάτων","Line Height":"Υψος γραμμής","Font Weight":"Βάρος γραμματοσειράς","Dyslexia Font":"Γραμματοσειρά για δυσλεξία","Language":"Γλώσσα"}'
    ),
    es: K,
    fr: $,
    hi: Y,
    it: tt,
    ja: Q,
    ko: X,
    zh: JSON.parse(
      '{"Accessibility Menu":"辅助功能菜单","Reset settings":"重置设置","Close":"关闭","Content Adjustments":"内容调整","Adjust Font Size":"调整字体大小","Highlight Title":"标题高亮","Highlight Links":"链接高亮","Readable Font":"易读字体","Color Adjustments":"色彩调整","Dark Contrast":"高对比度（黑色）","Light Contrast":"高对比度（白色）","High Contrast":"高对比度","High Saturation":"高饱和度","Low Saturation":"低饱和度","Monochrome":"单色","Tools":"工具","Reading Guide":"阅读指南","Stop Animations":"停止动画","Big Cursor":"大光标","Increase Font Size":"增加字体大小","Decrease Font Size":"减小字体大小","Letter Spacing":"字母间距","Line Height":"行距","Font Weight":"字重","Dyslexia Font":"阅读障碍字体","Language":"语言"}'
    ),
    id: et,
    pt: nt,
    he: it,
    ro: at,
    ms: ot,
  };
  function rt(t, e) {
    var n = t.getAttribute("data-translate");
    return (
      !n && e && ((n = e), t.setAttribute("data-translate", n)),
      (function (t) {
        return st.pt[t] || t;
      })(n)
    );
  }
  const lt = [
      {
        label: "Font Weight",
        key: "font-weight",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M13.5 15.5H10v-3h3.5A1.5 1.5 0 0 1 15 14a1.5 1.5 0 0 1-1.5 1.5m-3.5-9h3A1.5 1.5 0 0 1 14.5 8 1.5 1.5 0 0 1 13 9.5h-3m5.6 1.29c.97-.68 1.65-1.79 1.65-2.79 0-2.26-1.75-4-4-4H7v14h7.04c2.1 0 3.71-1.7 3.71-3.79 0-1.52-.86-2.82-2.15-3.42Z"/>\n</svg>',
      },
      {
        label: "Line Height",
        key: "line-height",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M21 22H3v-2h18v2m0-18H3V2h18v2m-11 9.7h4l-2-5.4-2 5.4M11.2 6h1.7l4.7 12h-2l-.9-2.6H9.4L8.5 18h-2l4.7-12Z"/>\n</svg>',
      },
      {
        label: "Letter Spacing",
        key: "letter-spacing",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M22 3v18h-2V3h2M4 3v18H2V3h2m6 10.7h4l-2-5.4-2 5.4M11.2 6h1.7l4.7 12h-2l-.9-2.6H9.4L8.5 18h-2l4.7-12Z"/>\n</svg>',
      },
      {
        label: "Highlight Links",
        key: "highlight-links",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M19 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2m0 16H5V5h14v14m-5.06-8.94a3.37 3.37 0 0 1 0 4.75L11.73 17A3.29 3.29 0 0 1 7 17a3.31 3.31 0 0 1 0-4.74l1.35-1.36-.01.6c-.01.5.07 1 .23 1.44l.05.15-.4.41a1.6 1.6 0 0 0 0 2.28c.61.62 1.67.62 2.28 0l2.2-2.19c.3-.31.48-.72.48-1.15 0-.44-.18-.83-.48-1.14a.87.87 0 0 1 0-1.24.91.91 0 0 1 1.24 0m4.06-.7c0 .9-.35 1.74-1 2.38l-1.34 1.36v-.6c.01-.5-.07-1-.23-1.44l-.05-.14.4-.42a1.6 1.6 0 0 0 0-2.28 1.64 1.64 0 0 0-2.28 0l-2.2 2.2c-.3.3-.48.71-.48 1.14 0 .44.18.83.48 1.14.17.16.26.38.26.62s-.09.46-.26.62a.86.86 0 0 1-.62.25.88.88 0 0 1-.62-.25 3.36 3.36 0 0 1 0-4.75L12.27 7A3.31 3.31 0 0 1 17 7c.65.62 1 1.46 1 2.36Z"/>\n</svg>',
      },
    ],
    ct = [
      {
        label: "Big Cursor",
        key: "big-cursor",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M11 1.07C7.05 1.56 4 4.92 4 9h7m-7 6a8 8 0 0 0 8 8 8 8 0 0 0 8-8v-4H4m9-9.93V9h7a8 8 0 0 0-7-7.93Z"/>\n</svg>',
      },
      {
        label: "Stop Animations",
        key: "stop-animations",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M22 12c0-5.54-4.46-10-10-10-1.17 0-2.3.19-3.38.56l.7 1.94A7.15 7.15 0 0 1 12 3.97 8.06 8.06 0 0 1 20.03 12 8.06 8.06 0 0 1 12 20.03 8.06 8.06 0 0 1 3.97 12c0-.94.19-1.88.53-2.72l-1.94-.66A10.37 10.37 0 0 0 2 12c0 5.54 4.46 10 10 10s10-4.46 10-10M5.47 3.97c.85 0 1.53.71 1.53 1.5C7 6.32 6.32 7 5.47 7c-.79 0-1.5-.68-1.5-1.53 0-.79.71-1.5 1.5-1.5M18 12c0-3.33-2.67-6-6-6s-6 2.67-6 6 2.67 6 6 6 6-2.67 6-6m-7-3v6H9V9m6 0v6h-2V9"/>\n</svg>',
      },
      {
        label: "Reading Guide",
        key: "readable-guide",
        icon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">\n  <path d="M12 8a3 3 0 0 0 3-3 3 3 0 0 0-3-3 3 3 0 0 0-3 3 3 3 0 0 0 3 3m0 3.54A13.15 13.15 0 0 0 3 8v11c3.5 0 6.64 1.35 9 3.54A13.15 13.15 0 0 1 21 19V8c-3.5 0-6.64 1.35-9 3.54Z"/>\n</svg>',
      },
    ];
  var dt = function () {
      return (
        (dt =
          Object.assign ||
          function (t) {
            for (var e, n = 1, i = arguments.length; n < i; n++)
              for (var a in (e = arguments[n]))
                Object.prototype.hasOwnProperty.call(e, a) && (t[a] = e[a]);
            return t;
          }),
        dt.apply(this, arguments)
      );
    },
    ut = { container: document.body };
  function gt(o) {
    return (
      (function (o) {
        var s,
          r,
          l = o.container,
          c = document.createElement("div");
        (c.innerHTML =
          '<style>.asw-menu,.asw-widget{-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;font-weight:400;-webkit-font-smoothing:antialiased}.asw-menu *,.asw-widget *{box-sizing:border-box}.asw-menu-btn{position:fixed;z-index:500000;right:20px;bottom:20px;background:#0048ff!important;box-shadow:0 5px 15px 0 rgb(37 44 97 / 15%),0 2px 4px 0 rgb(93 100 148 / 20%);transition:.3s;border-radius:50%;align-items:center;justify-content:center;transform:scale(1);width:54px;height:54px;display:flex;cursor:pointer;border:4px solid #fff!important;outline:4px solid #0048ff!important}.asw-menu-btn svg{width:30px;height:30px;min-height:30px;min-width:30px;max-width:30px;max-height:30px;background:0 0!important}.asw-menu-btn:hover{transform:scale(1.1)}@media only screen and (max-width:560px){.asw-menu-btn{width:38px;height:38px}.asw-menu-btn svg{width:24px;height:24px;min-height:24px;min-width:24px;max-width:24px;max-height:24px}}</style> <div class="asw-widget"> <button target="_blank" class="asw-menu-btn" title="Open Accessibility Menu" role="button" aria-expanded="false"> <svg xmlns="http://www.w3.org/2000/svg" style="fill:white" viewBox="0 0 24 24" width="30px" height="30px"> <path d="M0 0h24v24H0V0z" fill="none"/> <path d="M20.5 6c-2.61.7-5.67 1-8.5 1s-5.89-.3-8.5-1L3 8c1.86.5 4 .83 6 1v13h2v-6h2v6h2V9c2-.17 4.14-.5 6-1l-.5-2zM12 6c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2z"/> </svg> </button> </div> '),
          null === (s = c.querySelector(".asw-menu-btn")) ||
            void 0 === s ||
            s.addEventListener("click", function (o) {
              o.preventDefault(),
                r
                  ? t(r)
                  : (r = (function (o) {
                      var s,
                        r,
                        l,
                        c,
                        d = o.container,
                        u = document.createElement("div");
                      u.innerHTML = e;
                      var g = u.querySelector(".asw-amount");
                      (u.querySelector(".content").innerHTML = i(lt)),
                        (u.querySelector(".tools").innerHTML = i(
                          ct,
                          "asw-tools"
                        )),
                        (u.querySelector(".contrast").innerHTML = i(
                          n,
                          "asw-filter"
                        )),
                        (g.innerText = "".concat(
                          100 *
                            (null !== (s = A("fontSize")) && void 0 !== s
                              ? s
                              : 1),
                          "%"
                        )),
                        u
                          .querySelectorAll(".asw-menu-close, .asw-overlay")
                          .forEach(function (e) {
                            e.addEventListener("click", function () {
                              t(u, !1);
                            });
                          }),
                        u
                          .querySelectorAll(
                            ".asw-adjust-font div[role='button']"
                          )
                          .forEach(function (t) {
                            t.addEventListener("click", function () {
                              var e,
                                n =
                                  null !== (e = A("fontSize")) && void 0 !== e
                                    ? e
                                    : 1;
                              t.classList.contains("asw-minus")
                                ? (n -= 0.1)
                                : (n += 0.1),
                                (n = Math.max(n, 0.1)),
                                (n = Math.min(n, 3)),
                                a((n = Number(n.toFixed(2)))),
                                x({ fontSize: n });
                            });
                          }),
                        u.querySelectorAll(".asw-btn").forEach(function (t) {
                          t.addEventListener("click", function () {
                            var e,
                              n = t.dataset.key,
                              i = !t.classList.contains("asw-selected");
                            t.classList.contains("asw-filter")
                              ? (u
                                  .querySelectorAll(".asw-filter")
                                  .forEach(function (t) {
                                    t.classList.remove("asw-selected");
                                  }),
                                x({ contrast: !!i && n }),
                                i && t.classList.add("asw-selected"),
                                J())
                              : (t.classList.toggle("asw-selected", i),
                                x((((e = {})[n] = i), e)),
                                P());
                          });
                        }),
                        null === (r = u.querySelector(".asw-menu-reset")) ||
                          void 0 === r ||
                          r.addEventListener("click", function () {
                            C({ states: {} }), W();
                          });
                      var h = L();
                      if (
                        (C({ lang: "pt" }),
                        (function (t) {
                          t
                            .querySelectorAll(".asw-card-title, .asw-translate")
                            .forEach(function (t) {
                              t.innerText = rt(
                                t,
                                String(t.innerText || "").trim()
                              );
                            }),
                            t.querySelectorAll("[title]").forEach(function (t) {
                              t.setAttribute(
                                "title",
                                rt(t, t.getAttribute("title"))
                              );
                            });
                        })(u),
                        h.states)
                      )
                        for (var p in h.states)
                          if (h.states[p] && "fontSize" !== p) {
                            var m = "contrast" === p ? h.states[p] : p;
                            null ===
                              (c =
                                null ===
                                  (l = u.querySelector(
                                    '.asw-btn[data-key="'.concat(m, '"]')
                                  )) || void 0 === l
                                  ? void 0
                                  : l.classList) ||
                              void 0 === c ||
                              c.add("asw-selected");
                          }
                      return d.appendChild(u), u;
                    })({ container: c }));
            });
        try {
          var d = F();
          d ? (C(JSON.parse(d)), W()) : C({ lang: "pt" });
        } catch (t) {}
        l.appendChild(c);
      })({ container: dt(dt({}, ut), o).container }),
      {}
    );
  }
  document.addEventListener("DOMContentLoaded", function () {
    gt();
  });
})();

const HEADER_SELECTORS = [
  "h1",
  "h2",
  "h3",
  "h4",
  "h5",
  "h6",
  ".wsite-headline",
  ".wsite-content-title",
  "div",
];
const SELECTORS = [
  ...HEADER_SELECTORS,
  "img",
  "p",
  "i",
  "svg",
  "a",
  "button:not(.asw-btn)",
  "label",
  "li",
  "ol",
  "div",
  "section",
  "footer",
  "header",
];

const FILTERS = {
  "dark-contrast": {
    styles: {
      color: "#FFF",
      fill: "#FFF",
      "background-color": "#000",
    },
    childrenSelector: SELECTORS,
  },
};
const STORAGE_KEY = "contrast";

let contrastSettings = {
  darkcontrast: false,
};

// ---------------- SETTINGS ----------------

function getSettings() {
  const savedSettings = localStorage.getItem(STORAGE_KEY);
  if (savedSettings) {
    contrastSettings = JSON.parse(savedSettings);
  } else {
    contrastSettings = {
      darkcontrast: false,
    };
  }
  return contrastSettings;
}

function saveSettings() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(contrastSettings));
}

// ---------------- MAIN ----------------
function renderFilter() {
  let { darkcontrast } = getSettings();

  let contrastCss = "";

  let contrastFilter = false;

  if (darkcontrast) {
    contrastFilter = FILTERS["dark-contrast"];
  }
  if (contrastFilter) {
    contrastCss = generateCSSFromConfig({
      ...contrastFilter,
      selector: `html.aws-filter`,
    });
  }

  addStylesheet({
    css: contrastCss,
    id: "asw-filter-style",
  });

  document.documentElement.classList.toggle(
    "aws-filter",
    Boolean(darkcontrast)
  );
}

// ---------------- CSSGENERATOR ----------------

function addStylesheet({ css, id }) {
  if (css) {
    let style =
      document.getElementById(id || "") || document.createElement("style");
    style.innerHTML = css;
    if (!style.id) {
      style.id = id;
      document.head.appendChild(style);
    }
  }
}

const browserPrefixes = ["-o-", "-ms-", "-moz-", "-webkit-", ""];
const propertiesNeedPrefix = ["filter"];

function generateCSS(styles) {
  let css = "";

  if (styles) {
    for (let key in styles) {
      let prefixes = propertiesNeedPrefix.includes(key)
        ? browserPrefixes
        : [""];
      prefixes.forEach((prefix) => {
        css += `${prefix}${key}:${styles[key]} !important;`;
      });
    }
  }

  return css;
}
function wrapCSSToSelector({ selector, childrenSelector = [""], css }) {
  let output = "";

  childrenSelector.forEach((childSelector) => {
    output += `${selector} ${childSelector}{${css}}`;
  });

  return output;
}

function generateCSSFromConfig(config) {
  let output = "";

  if (config) {
    output += config.css ?? "";
    output += generateCSS(config.styles);

    if (output.length && config.selector) {
      output = wrapCSSToSelector({
        selector: config.selector,
        childrenSelector: config.childrenSelector,
        css: output,
      });
    }
  }

  return output;
}

function injectToolCSS(config) {
  let { id = "", enable = false } = config;

  let toolId = `asw-${id}`;

  if (enable) {
    let css = generateCSSFromConfig(config);

    addStylesheet({
      css,
      id: toolId,
    });
  } else {
    document.getElementById(toolId)?.remove();
  }

  document.documentElement.classList.toggle(toolId, enable);
}

// ----------------

const contrastButtonFunc = () => {
  document.addEventListener("DOMContentLoaded", function () {
    renderFilter();
    var contrastButton = document.getElementById("contrast-button");
    if (contrastButton) {
      contrastButton.addEventListener("click", function () {
        contrastSettings.darkcontrast = !contrastSettings.darkcontrast;
        saveSettings();
        renderFilter();
      });
    }
  });
};

export { contrastButtonFunc };
