
hasLocalStorage = if localStorage then true else false
markyBtn = document.getElementById("marky-btn")

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

    documentHeight = document.height
    windowHeight = window.innerHeight

    Object.size = (obj) ->
        size = 0
        for key in obj
            size++ if obj.hasOwnProperty(key)
        return size

    markyBtn.onclick = (e) ->
        e.preventDefault()
        scrollPos = document.body.scrollTop
        this.className = "active"
        document.getElementById("marky-text-container").style.display = "block"
        savePosition(scrollPos)
        return

    savePosition = (pos) ->
        now = new Date()
        nowDateString = now.getMonth() + "/" + now.getDate() + "- " + now.getHours() + ":" + now.getMinutes()
        obj = {}
        obj[pos] = nowDateString

        if (localStorage.getItem("marky-btn"))
            markyStore = JSON.parse( localStorage.getItem "marky-btn" )
            markyStore[pos] = nowDateString

        if (markyStore) then obj = markyStore

        localStorage.setItem( "marky-btn", JSON.stringify(obj) )
        renderPositions()
        return

    getPositions = () ->
        JSON.parse(localStorage.getItem("marky-btn"))

    renderPositions = () ->
        markPositions = getPositions()
        console.log("markPositions:", markPositions)
        for position of markPositions
            top = Math.floor((position/(documentHeight - windowHeight)) * windowHeight) + "px"
            console.log("percentage:", top)
            temp = document.createElement('a')
            temp.href = '#'
            temp.innerHTML = "<span>blah</span>"
            temp.className = 'marky-mark'
            temp.style.top = top
            temp.setAttribute("data-loc", position)
            document.getElementsByTagName('body')[0].appendChild(temp)

        markers = document.getElementsByClassName('marky-mark')
        for marker in markers
            marker.onclick = (e) ->
                e.preventDefault()
                this.className = this.className + " active"
                pos = this.getAttribute("data-loc")
                window.scrollTo(0, pos);
                return
        return


    renderPositions()

