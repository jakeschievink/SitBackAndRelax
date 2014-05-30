# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
    screenHeight = $(window).height()
    $theproblem = $("#theproblem")
    $firstbg = $("#firstbg")
    $secondbg = $("#secondbg")
    $newpost = $("#newpost")
    $newpost.css('top', screenHeight-50)
    allStories = []
    selectedStory = {}
    audio = new Audio('/theSound.wav')
    audio.addEventListener('ended', ()->
            this.currentTime = 0
            this.play()
    , false)
    audio.play()
    #this is where the stories start
    $.get(
        "/posts.json",
        (resp)->
            allStories = sortByKey(resp, "votes")
            console.log(JSON.stringify(allStories))
            loadStory(resp)
            setInterval(cycleBackground, 5000)
    )

    # gets the probability of an element in the list being chosen 
    getProbablility= (length,element)->
        return -Math.log(element/(length+2))/4
    # badly written function to more likely select the first elements in a list and less likely select the last
    getWeightedRandomElementNumber = (list)->
        compare = Math.random()
        chosenElement= Math.floor(Math.random()*list.length)
        if(compare < getProbablility(list.length, chosenElement))
           return chosenElement
        else
            getWeightedRandomElementNumber(list)
        




    loadStory  = (list) ->
        $theproblem.css('top', screenHeight+200)
        $theproblem.css('opacity', "50")
        selectedStory = list[Math.floor(Math.random()*list.length)]
        sortedElems = sortByKey(list, "votes").reverse()
        console.log("sorted: ",sortedElems)
        selectedStory = sortedElems[getWeightedRandomElementNumber(sortedElems)]
        
        $theproblem.html(selectedStory.title)
        $theproblem.animate({"top":screenHeight-50+"px"}, "slow").delay(2000)
        $theproblem.animate({"top":screenHeight-400+"px","opacity":"0"}, "slow",()->loadStory(list))

    $theproblem.click((e)-> addVote(selectedStory.id, (selectedStory.votes || 1) + 1))
    $("#newpost").click((e)-> window.location.href = "/posts/new")
    addVote = (id, votes) ->
        $.ajax({
            url: "/posts/"+id,
            type: "PUT",
            data: JSON.stringify({"votes":votes}),
            dataType: 'json',
            contentType: 'application/json',
            success: (resp) ->
                window.location.href = selectedStory.storyurl

        })
    sortByKey = (arrOfObj, key)->
        slicedObj = arrOfObj.slice(0)
        slicedObj.sort((a,b)->
            return a[key] - b[key])
        return slicedObj

    selected = $firstbg
    cycleBackground = ()->
        img = new Image()
        img.src = '/assets/'+Math.floor(Math.random()*50)+'.jpg'
        img.onload = ()->
            $secondbg.fadeToggle("slow", ()->
                selected = (if selected == $firstbg then  selected = $secondbg  else selected =$firstbg)
                changeBackground(selected, img.src))

    changeBackground = (elem, src)->
        console.log("elem: ", elem)
        elem.css('background-image','url('+src+')')


