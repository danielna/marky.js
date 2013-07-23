# Todo:
# Delete marks when active
# Figure out the FE
# Distinguish overlapping marks somehow

hasLocalStorage = if localStorage then true else false
markyBtn = document.getElementById("marky-btn")

_markycss = document.createElement('link');
_markycss.setAttribute('href','css/marky.css');
_markycss.setAttribute('rel','stylesheet');
_markycss.setAttribute('type','text/css');
document.getElementsByTagName('head')[0].appendChild(_markycss);

# FF detection hack
FF = window.mozInnerScreenX is not null

if (hasLocalStorage and not markyBtn)
    markyBtnDom = document.createElement('a')
    markyBtnDom.id = 'marky-btn'
    markyBtnDom.href = '#'
    markyBtnDom.innerHTML = 'mark!' 
    document.getElementsByTagName('body')[0].appendChild(markyBtnDom)

    markyTextDiv = document.createElement('div')
    markyTextDiv.id = 'marky-text-container'
    markyTextDiv.innerHTML = '<input type="text" id="marky-text">' 
    document.getElementsByTagName('body')[0].appendChild(markyTextDiv)

    markyBtn = document.getElementById("marky-btn")

    D = document
    documentHeight = Math.max(
        D.body.scrollHeight, D.documentElement.scrollHeight,
        D.body.offsetHeight, D.documentElement.offsetHeight,
        D.body.clientHeight, D.documentElement.clientHeight
    )

    windowHeight = window.innerHeight

    Object.size = (obj) ->
        size = 0
        for key in obj
            size++ if obj.hasOwnProperty(key)
        return size

    markyBtn.onclick = (e) ->
        e.preventDefault()
        if this.className is "active"
            return resetAll()
        markyTextContainer = document.getElementById("marky-text-container")
        markyText = document.getElementById("marky-text")
        # FF detection hack
        scrollPos = if FF then document.documentElement.scrollTop else document.body.scrollTop
        this.className = "active"
        markyTextContainer.style.display = "block"
        markyTextContainer.setAttribute("data-pos", scrollPos)
        markyText.onkeypress = (e) ->
            if e.keyCode is 13
                savePosition(markyTextContainer.getAttribute("data-pos"), markyText.value)
            return
        return

    savePosition = (pos, name) ->
        now = new Date()
        nowDateString = now.getMonth() + "/" + now.getDate() + "- " + now.getHours() + ":" + now.getMinutes()
        obj = {}
        name = name ? ""
        obj[pos] = name

        if (localStorage.getItem("marky-btn"))
            markyStore = JSON.parse( localStorage.getItem "marky-btn" )
            markyStore[pos] = name

        if (markyStore) then obj = markyStore

        localStorage.setItem( "marky-btn", JSON.stringify(obj) )
        renderPositions()
        resetAll()
        return

    removePosition = (pos) ->
        if (localStorage.getItem("marky-btn"))
            markyStore = JSON.parse( localStorage.getItem "marky-btn" )
            delete(markyStore[pos]) if markyStore[pos]
            localStorage.setItem( "marky-btn", JSON.stringify(markyStore) )
            renderPositions()
            resetAll()
        return

    getPositions = () ->
        JSON.parse(localStorage.getItem("marky-btn"))

    clearOldPositions = () ->
        markers = document.getElementsByClassName('marky-mark')
        for marker in markers
            if (marker)
                marker.parentNode.removeChild(marker)

    renderPositions = () ->
        clearOldPositions()

        markPositions = getPositions()
        for position of markPositions
            top = Math.floor((position/(documentHeight - windowHeight)) * windowHeight) + "px"
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
                    removePosition(removeLocation)
                    renderPositions()
                else
                    this.className = this.className + " active"
                    pos = this.getAttribute("data-loc")
                    window.scrollTo(0, pos);
                    resetMarkers()
                return
        return

    resetMarkers = () ->
        markers = document.getElementsByClassName('marky-mark')
        for marker in markers
            marker.className = "marky-mark"
        return

    resetAll = () ->
        document.getElementById("marky-text-container").style.display = "none"
        document.getElementById("marky-text-container").removeAttribute("data-pos")
        document.getElementById("marky-text").value = ""
        document.getElementById("marky-btn").className = ""



    renderPositions()

