
isLocalStorage = if localStorage then true else false
markyBtn = document.getElementById "marky-btn"

if (isLocalStorage and markyBtn)
    Object.size = (obj) ->
        size = 0
        for key in obj
            size++ if obj.hasOwnProperty(key)
        return size

    markyBtn.onclick = (e) ->
        e.preventDefault()
        scrollPos = document.body.scrollTop
        savePosition(scrollPos)
        return

    savePosition = (pos) ->
        now = new Date().toString()
        obj = {}
        obj[now] = pos

        if (localStorage.getItem("marky-btn"))
            markyStore = JSON.parse( localStorage.getItem "marky-btn" )
            markyStore[now] = pos

        if (markyStore) then obj = markyStore

        localStorage.setItem( "marky-btn", JSON.stringify(obj) )
        return

    getPositions = () ->
        JSON.parse(localStorage.getItem("marky-btn"))


