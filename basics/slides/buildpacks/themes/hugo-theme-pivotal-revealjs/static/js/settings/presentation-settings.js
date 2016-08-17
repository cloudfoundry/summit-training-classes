(function( root, factory ) {
	if( typeof define === 'function' && define.amd ) {
		// AMD. Register as an anonymous module.
		define( function() {
			root.PresentationSettings = factory();
			return root.PresentationSettings;
		} );
	} else if( typeof exports === 'object' ) {
		// Node. Does not work with strict CommonJS.
		module.exports = factory();
	} else {
		// Browser globals.
		root.PresentationSettings = factory();
	}
}( this, function() {

	'use strict';

	var PresentationSettings;

  PresentationSettings = {
    cookieName: "presentation-settings",

    config: {
      presenterName: "",
      presenterTitle: "",
      presenterContact: "",
      showNotes: false
    },

    updateDisplay: function() {
      var settings = this;
      settings.updateDisplayedValues();
      settings.updateForm();
    },

    updateDisplayedValues: function() {
      var settings = this;
      $('.presenter-name').html(settings.config.presenterName);
      $('.presenter-title').html(settings.config.presenterTitle);
      $('.presenter-contact').html(settings.config.presenterContact);
      Reveal.configure({ showNotes: settings.config.showNotes});
    },

    updateForm: function() {
      var settings = this;
      $('#presenterName').val(settings.config.presenterName);
      $('#presenterTitle').val(settings.config.presenterTitle);
      $('#presenterContact').val(settings.config.presenterContact);
      settings.updateSelectedOptionDisplay("showNotes",settings.config.showNotes);
    },

    updateSelectedOptionDisplay: function(name, value) {
      if (value) {
        $('#' + name).addClass("fa fa-check-circle");
        $('#' + name).removeClass("fa-circle-thin");
      } else {
        $('#' + name).addClass("fa fa-circle-thin");
        $('#' + name).removeClass("fa-check-circle");
      }
    },

    setCookie: function() {
      var settings = this;
      Cookies.set(settings.cookieName,
          settings.config,
          { expires: 365 });
    },

    updateFromCookie: function() {
      var settings = this;
      var json = Cookies.getJSON(settings.cookieName);
      if ( json ) {
        settings.config = json;
      }
      settings.updateDisplay();
    },

    updateFromForm: function() {
      var settings = this;
      settings.config.presenterName = $('#presenterName').val().trim();
      settings.config.presenterTitle = $('#presenterTitle').val().trim();
      settings.config.presenterContact = $('#presenterContact').val().trim();
      settings.config.showNotes = $('#showNotes').hasClass("fa-check-circle");
      settings.setCookie();
      settings.updateDisplay();
    },

    toggleShowNotes: function() {
      var settings = this;
      var value = true;
      if ( settings.config.showNotes ) {
          value = false;
      }
      settings.updateSelectedOptionDisplay("showNotes", value);
    }

  };

  return PresentationSettings;

}));
/*
var presenter = Cookies.getJSON("presenter");
if ( presenter ) {
  setPresenterValues(presenter['name'], presenter['title'], presenter['contact']);
}

function setPresenterCookie(name, title, contact) {
  Cookies.set("presenter", {"name": name, "title": title, "contact": contact}, { expires: 365 });
}

function setPresenterValues(name, title, contact) {
  $('.presenter-name').html(name);
  $('.presenter-title').html(title);
  $('.presenter-contact').html(contact);
}

function updatePresenterForm() {
  if ( presenter ) {
    $('#presenterName').val(presenter['name']);
    $('#presenterTitle').val(presenter['title']);
    $('#presenterContact').val(presenter['contact']);
  }
}

function updatePresenter() {
  var name = $('#presenterName').val();
  var title = $('#presenterTitle').val();
  var contact = $('#presenterContact').val();
  setPresenterCookie(name, title, contact);
  setPresenterValues(name, title, contact);
}

var availableRevealSettings = ['showNotes'];

var settings = Cookies.getJSON("presentation-settings");
if ( ! settings || settings.length == 0 ) {
  settings = [];
  for (var i = 0; i < availableRevealSettings.length; i++) {
    settings[availableRevealSettings[i]] = false;
  }
}

function setPresentationSettingsCookie(settings) {
  Cookies.set("presentation-settings", settings, { expires: 365 });
}

function updateRevealSettings(settings) {
  var config = Reveal.getConfig();
  for ( key in availableRevealSettings ) {
    Reveal.configure({ key: settings[key] });
  }
}

function updateSettingsDisplay() {
  var config = Reveal.getConfig();
  for (var i = 0; i < availableRevealSettings.length; i++) {
    if (config[availableRevealSettings[i]]) {
      $('#' + availableRevealSettings[i]).addClass("fa fa-check-circle");
      $('#' + availableRevealSettings[i]).removeClass("fa-circle-thin");
    } else {
      $('#' + availableRevealSettings[i]).addClass("fa fa-circle-thin");
      $('#' + availableRevealSettings[i]).removeClass("fa-check-circle");
    }
  }
}

function toggleSetting(setting) {
  if ( settings[setting] ) {
    settings[setting] = false;
  } else {
    settings[setting] = true;
  }
  setPresentationSettingsCookie(settings);
  updateRevealSettings(settings);
  updateSettingsDisplay();
}

function updateFormDisplay() {
  updateRevealSettings(settings);
  updateSettingsDisplay();
  updatePresenterForm();
}
*/
