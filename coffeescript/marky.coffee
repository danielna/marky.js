# Todo:
# If marky is loaded, don't load it again.

Object.size = (obj) ->
    size = 0
    for key in obj
        size++ if obj.hasOwnProperty(key)
    return size

class Marky
    constructor: () ->
        hasLocalStorage = if localStorage then true else false
        if window._marky
            this.destroy()
            return
        else if hasLocalStorage
            this.init()
        else
            console.error "Something went wrong or LocalStorage is not enabled in your browser."

    init: () ->
        window._marky = this
        @isFF = (window.mozInnerScreenX != null)
        @markyBtn
        @markyTextContainer
        @markyTextBox
        @documentHeight = Math.max(
            document.body.scrollHeight, document.documentElement.scrollHeight,
            document.body.offsetHeight, document.documentElement.offsetHeight,
            document.body.clientHeight, document.documentElement.clientHeight
            )
        @windowHeight = window.innerHeight

        # the jump off
        this.injectCss()
        this.createDomElements()
        this.renderPositions()
        return

    injectCss: () ->
        _markycss = document.createElement('link')
        _markycss.setAttribute('href','http://labs.danielna.com/marky/marky.min.css')
        _markycss.setAttribute('rel','stylesheet')
        _markycss.setAttribute('type','text/css')
        _markycss.id = "marky-css"
        document.getElementsByTagName('head')[0].appendChild(_markycss)
        return

    createDomElements: () ->
        self = this

        # the mark! button
        markyBtnDom = document.createElement('a')
        markyBtnDom.id = 'marky-btn'
        markyBtnDom.href = '#'
        markyBtnDom.innerHTML = 'mark!' 
        document.getElementsByTagName('body')[0].appendChild(markyBtnDom)

        # the text input box
        markyTextDiv = document.createElement('div')
        markyTextDiv.id = 'marky-text-container'
        markyTextDiv.innerHTML = '<input type="text" id="marky-text">' 
        document.getElementsByTagName('body')[0].appendChild(markyTextDiv)

        @markyBtn = document.getElementById("marky-btn")
        @markyTextContainer = document.getElementById("marky-text-container")
        @markyTextBox = document.getElementById("marky-text")

        # create the click handler for the mark! button
        @markyBtn.onclick = (e) ->
            e.preventDefault()

            if this.className is "active"
                return self.resetAll()

            # FF detection hack
            scrollPos = if self.isFF then document.documentElement.scrollTop else document.body.scrollTop

            this.className = "active"
            self.markyTextContainer.style.display = "block"
            self.markyTextContainer.setAttribute("data-pos", scrollPos)

            self.markyTextBox.onkeypress = (e) ->
                if e.keyCode is 13
                    self.savePosition(self.markyTextContainer.getAttribute("data-pos"), self.markyTextBox.value)
                return
            return
        return

    savePosition: (pos, name) ->
        obj = {}
        obj[pos] = name ? ""

        if (localStorage.getItem("marky-btn"))
            markyStore = JSON.parse( localStorage.getItem "marky-btn" )
            markyStore[pos] = name

        if (markyStore) then obj = markyStore

        localStorage.setItem( "marky-btn", JSON.stringify(obj) )
        this.renderPositions()
        this.resetAll()
        return

    removePosition: (pos) ->
        if (localStorage.getItem("marky-btn"))
            markyStore = JSON.parse( localStorage.getItem "marky-btn" )
            delete(markyStore[pos]) if markyStore[pos]
            localStorage.setItem( "marky-btn", JSON.stringify(markyStore) )
            this.renderPositions()
            this.resetAll()
        return

    getPositions: () ->
        JSON.parse(localStorage.getItem("marky-btn"))

    clearOldPositions: () ->
        markers = document.getElementsByClassName('marky-mark')
        for marker in markers
            if (marker)
                marker.parentNode.removeChild(marker)

    renderPositions: () ->
        self = this
        this.clearOldPositions()

        markPositions = this.getPositions()
        for position of markPositions
            top = Math.floor((position/(@documentHeight - @windowHeight)) * @windowHeight) + "px"
            temp = document.createElement('div')
            temp.innerHTML = "<span class='title'>" + markPositions[position] + "</span><span class='close' title='Delete'>[x]</span><span class='edge'></span>"
            temp.className = 'marky-mark'
            temp.style.top = top
            temp.setAttribute("data-loc", position)
            document.getElementsByTagName('body')[0].appendChild(temp)

        markers = document.getElementsByClassName('marky-mark')
        for marker in markers
            marker.onclick = (e) ->
                e.preventDefault()
                target = e.target
                if target.className is "close"
                    removeLocation = target.parentNode.getAttribute("data-loc")
                    self.removePosition(removeLocation)
                    self.renderPositions()
                else
                    this.className = this.className + " active"
                    pos = this.getAttribute("data-loc")
                    window.scrollTo(0, pos);
                    self.resetMarkers()
                return
        return

    resetMarkers: () ->
        markers = document.getElementsByClassName('marky-mark')
        for marker in markers
            marker.className = "marky-mark"
        return

    resetAll: () ->
        @markyTextContainer.style.display = "none"
        @markyTextContainer.removeAttribute("data-pos")
        @markyTextBox.value = ""
        @markyBtn.className = ""

    destroy: () ->
        css = document.getElementById("marky-css")
        js = document.getElementById("marky-script")
        btn = document.getElementById("marky-btn")
        txtcontainer = document.getElementById("marky-text-container")
        markers = document.getElementsByClassName('marky-mark')
        for marker in markers by -1
            if (marker)
                marker.parentNode.removeChild(marker)

        btn.parentNode.removeChild(btn)
        txtcontainer.parentNode.removeChild(txtcontainer)
        css.parentNode.removeChild(css)
        js.parentNode.removeChild(js)
        window._marky = null

Marky = new Marky()

