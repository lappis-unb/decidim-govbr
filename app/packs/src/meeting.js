document.addEventListener("DOMContentLoaded", function() {
  const getMettingType = document.getElementById('meeting_type_of_meeting')
  const getPresentialMeetingContainer = document.getElementById('presential-meeting')
  const getOnlineMeetingContainer = document.getElementById('location-hints-meeting')
  const iframeMeeting = document.getElementById('meeting_url_iframe')
  const urlVideoMeeting = document.getElementById('meeting_online_meeting_url')

  function getYoutubeEmbedUrl(url) {
    var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
    var match = url.match(regExp);
    if (match && match[2].length == 11) {
      return 'https://www.youtube.com/embed/' + match[2];
    } else {
      return null;
    }
  }

  function isYoutubeUrl(url) {
    if (url.includes ('youtube.com') || url.includes ('youtu.be')) {
      return true
    }
  }
  
  if (urlVideoMeeting) {
    urlVideoMeeting.addEventListener('input', function() {
      var embedUrl = getYoutubeEmbedUrl(urlVideoMeeting.value);
      if (embedUrl && isYoutubeUrl(urlVideoMeeting.value)) {
        iframeMeeting.style.display = 'block'
        iframeMeeting.src = embedUrl;
      } else {
        iframeMeeting.style.display = 'none'
        iframeMeeting.src = ''
      }
    })
  }

  if (getMettingType) {
    getMettingType.addEventListener('change', function() {
      meetingType = getMettingType.value;
      
      if (meetingType === 'in_person'){
        getPresentialMeetingContainer.style.display = 'block';
        getOnlineMeetingContainer.style.display = 'block';
      } 
      else if (meetingType === 'online'){
        getOnlineMeetingContainer.style.display = 'none';
        getPresentialMeetingContainer.style.display = 'none';
      }
      else if (meetingType === 'hybrid'){
        getPresentialMeetingContainer.style.display = 'block';
        getOnlineMeetingContainer.style.display = 'block';
      } 
      else {
        getPresentialMeetingContainer.style.display = 'none';
        getOnlineMeetingContainer.style.display = 'none';
      }
    })
  }

  var radios = document.querySelectorAll('.meeting_registration_type');

  var meeting_slots = document.getElementById('meeting_available_slots');
  var meeting_terms = document.getElementById('meeting_registration_terms');
  var meeting_url = document.getElementById('meeting_registration_url');

  radios.forEach(function(radio) {
    radio.addEventListener('change', function(event) {
  
      console.log(event.target.value)
      if(event.target.value === 'on_this_platform') {
        meeting_slots.style.display = 'block';
        meeting_terms.style.display = 'block';
        meeting_url.style.display = 'none';
      }
      else if(event.target.value === 'on_different_platform') {
        meeting_url.style.display = 'block';
        meeting_slots.style.display = 'none';
        meeting_terms.style.display = 'none';
      }
      else {
        meeting_slots.style.display = 'none';
        meeting_terms.style.display = 'none';
        meeting_url.style.display = 'none';
      }
    });
  });
})