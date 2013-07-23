// Generated by CoffeeScript 1.6.3
(function() {
  var Marky;

  Object.size = function(obj) {
    var key, size, _i, _len;
    size = 0;
    for (_i = 0, _len = obj.length; _i < _len; _i++) {
      key = obj[_i];
      if (obj.hasOwnProperty(key)) {
        size++;
      }
    }
    return size;
  };

  Marky = (function() {
    function Marky() {
      var hasLocalStorage;
      hasLocalStorage = localStorage ? true : false;
      if (window._marky) {
        this.destroy();
        return;
      } else if (hasLocalStorage) {
        this.init();
      } else {
        console.error("Something went wrong or LocalStorage is not enabled in your browser.");
      }
    }

    Marky.prototype.init = function() {
      window._marky = this;
      this.isFF = window.mozInnerScreenX !== null;
      this.markyBtn;
      this.markyTextContainer;
      this.markyTextBox;
      this.documentHeight = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight, document.body.offsetHeight, document.documentElement.offsetHeight, document.body.clientHeight, document.documentElement.clientHeight);
      this.windowHeight = window.innerHeight;
      this.injectCss();
      this.createDomElements();
      this.renderPositions();
    };

    Marky.prototype.injectCss = function() {
      var _markycss;
      _markycss = document.createElement('link');
      _markycss.setAttribute('href', 'css/marky.css');
      _markycss.setAttribute('rel', 'stylesheet');
      _markycss.setAttribute('type', 'text/css');
      _markycss.id = "marky-css";
      document.getElementsByTagName('head')[0].appendChild(_markycss);
    };

    Marky.prototype.createDomElements = function() {
      var markyBtnDom, markyTextDiv, self;
      self = this;
      markyBtnDom = document.createElement('a');
      markyBtnDom.id = 'marky-btn';
      markyBtnDom.href = '#';
      markyBtnDom.innerHTML = 'mark!';
      document.getElementsByTagName('body')[0].appendChild(markyBtnDom);
      markyTextDiv = document.createElement('div');
      markyTextDiv.id = 'marky-text-container';
      markyTextDiv.innerHTML = '<input type="text" id="marky-text">';
      document.getElementsByTagName('body')[0].appendChild(markyTextDiv);
      this.markyBtn = document.getElementById("marky-btn");
      this.markyTextContainer = document.getElementById("marky-text-container");
      this.markyTextBox = document.getElementById("marky-text");
      this.markyBtn.onclick = function(e) {
        var scrollPos;
        e.preventDefault();
        if (this.className === "active") {
          return self.resetAll();
        }
        scrollPos = self.isFF ? document.documentElement.scrollTop : document.body.scrollTop;
        alert("@isFF:" + self.isFF);
        alert("scrollPos:" + scrollPos);
        this.className = "active";
        self.markyTextContainer.style.display = "block";
        self.markyTextContainer.setAttribute("data-pos", scrollPos);
        self.markyTextBox.onkeypress = function(e) {
          if (e.keyCode === 13) {
            self.savePosition(self.markyTextContainer.getAttribute("data-pos"), self.markyTextBox.value);
          }
        };
      };
    };

    Marky.prototype.savePosition = function(pos, name) {
      var markyStore, obj;
      obj = {};
      obj[pos] = name != null ? name : "";
      if (localStorage.getItem("marky-btn")) {
        markyStore = JSON.parse(localStorage.getItem("marky-btn"));
        markyStore[pos] = name;
      }
      if (markyStore) {
        obj = markyStore;
      }
      localStorage.setItem("marky-btn", JSON.stringify(obj));
      this.renderPositions();
      this.resetAll();
    };

    Marky.prototype.removePosition = function(pos) {
      var markyStore;
      if (localStorage.getItem("marky-btn")) {
        markyStore = JSON.parse(localStorage.getItem("marky-btn"));
        if (markyStore[pos]) {
          delete markyStore[pos];
        }
        localStorage.setItem("marky-btn", JSON.stringify(markyStore));
        this.renderPositions();
        this.resetAll();
      }
    };

    Marky.prototype.getPositions = function() {
      return JSON.parse(localStorage.getItem("marky-btn"));
    };

    Marky.prototype.clearOldPositions = function() {
      var marker, markers, _i, _len, _results;
      markers = document.getElementsByClassName('marky-mark');
      _results = [];
      for (_i = 0, _len = markers.length; _i < _len; _i++) {
        marker = markers[_i];
        if (marker) {
          _results.push(marker.parentNode.removeChild(marker));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Marky.prototype.renderPositions = function() {
      var markPositions, marker, markers, position, self, temp, top, _i, _len;
      self = this;
      this.clearOldPositions();
      markPositions = this.getPositions();
      for (position in markPositions) {
        top = Math.floor((position / (this.documentHeight - this.windowHeight)) * this.windowHeight) + "px";
        temp = document.createElement('div');
        temp.innerHTML = "<span class='title'>" + markPositions[position] + "</span><span class='close' title='Delete'>[x]</span><span class='edge'></span>";
        temp.className = 'marky-mark';
        temp.style.top = top;
        temp.setAttribute("data-loc", position);
        document.getElementsByTagName('body')[0].appendChild(temp);
      }
      markers = document.getElementsByClassName('marky-mark');
      for (_i = 0, _len = markers.length; _i < _len; _i++) {
        marker = markers[_i];
        marker.onclick = function(e) {
          var pos, removeLocation, target;
          e.preventDefault();
          target = e.target;
          if (target.className === "close") {
            removeLocation = target.parentNode.getAttribute("data-loc");
            self.removePosition(removeLocation);
            self.renderPositions();
          } else {
            this.className = this.className + " active";
            pos = this.getAttribute("data-loc");
            window.scrollTo(0, pos);
            self.resetMarkers();
          }
        };
      }
    };

    Marky.prototype.resetMarkers = function() {
      var marker, markers, _i, _len;
      markers = document.getElementsByClassName('marky-mark');
      for (_i = 0, _len = markers.length; _i < _len; _i++) {
        marker = markers[_i];
        marker.className = "marky-mark";
      }
    };

    Marky.prototype.resetAll = function() {
      this.markyTextContainer.style.display = "none";
      this.markyTextContainer.removeAttribute("data-pos");
      this.markyTextBox.value = "";
      return this.markyBtn.className = "";
    };

    Marky.prototype.destroy = function() {
      var btn, css, js, marker, markers, txtcontainer, _i;
      css = document.getElementById("marky-css");
      js = document.getElementById("marky-script");
      btn = document.getElementById("marky-btn");
      txtcontainer = document.getElementById("marky-text-container");
      markers = document.getElementsByClassName('marky-mark');
      for (_i = markers.length - 1; _i >= 0; _i += -1) {
        marker = markers[_i];
        if (marker) {
          marker.parentNode.removeChild(marker);
        }
      }
      btn.parentNode.removeChild(btn);
      txtcontainer.parentNode.removeChild(txtcontainer);
      css.parentNode.removeChild(css);
      js.parentNode.removeChild(js);
      return window._marky = null;
    };

    return Marky;

  })();

  Marky = new Marky();

}).call(this);
