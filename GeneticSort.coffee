class GeneticSort
    constructor:(@inputList)->
        console.log('start')

    GetSortedArray:()->
        @_initilizePool()
        @_getGenerationTotalHealth()
        return @_GetBest(@generation)


    _shuffle:(array)->
        rtrnarr =array.slice(0)
        randomIndex = 0
        temporaryValue = 0
        currentIndex = rtrnarr.length
        while (0 != currentIndex) 
            ## Pick a remaining element...
            randomIndex = Math.floor(Math.random() * currentIndex)
            currentIndex -= 1

            ## And swap it with the current element.
            temporaryValue = rtrnarr[currentIndex]
            rtrnarr[currentIndex] = rtrnarr[randomIndex]
            rtrnarr[randomIndex] = temporaryValue
        return rtrnarr

    _getGenerationTotalHealth:()->
        @totalHealth = 0
        for specimen in @generation
            @totalHealth = @totalHealth + specimen.health

    _initilizePool:()->
        @generation = []
        for i in [1..200]
            specimen = @_shuffle(@inputList)
            @generation.push({"health":@_checkHealth(specimen),"pool":specimen})

    _checkHealth:(array)->
        runningHealth = 0
        for i in [0..array.length-1]
            current = array[i]
            if(i!=0)
                previous =array[i-1]
                if(previous.BandName!=null && current.BandName!=null && previous.BandName == current.BandName)
                    runningHealth--
        return runningHealth

    ##_NextGen:()->
    _GetBest:(arr)->
        arr.sort((a,b)->
            return b.health-a.health
        )
        console.log("Best Individual: "+ arr[0].health)
        console.log("Total Health: "+ @totalHealth)
        return arr[0].pool



