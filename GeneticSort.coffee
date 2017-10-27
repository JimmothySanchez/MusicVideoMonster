class GeneticSort
    constructor:(@inputList)->
        console.log('start')
        @GenrationSize = 200
        @NumberOfGenerations =200
        @PercentOfRecordsToMutate = 10
        @PercentageLevelOfMutation = 40

    GetSortedArray:()->
        @_initilizePool()
        for i in [1..@NumberOfGenerations]
            console.log('Generation: '+i)
            @_getGenerationTotalHealth()
            console.log('determined health')
            @_GetBest(@generation)
            @_getNextGeneration()
            console.log('Get next gen')
            @_mutate()
            console.log('Mutate')
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
            specimen.health = @_checkHealth(specimen.pool)
            @totalHealth = @totalHealth + specimen.health

    _initilizePool:()->
        @generation = []
        for i in [1..@GenrationSize]
            specimenPool = @_shuffle(@inputList)
            @generation.push({"health":@_checkHealth(specimenPool),"pool":specimenPool})

    _getNextGeneration:()->
        tempGen = []
        for specimen in @generation
            specimen.relativeHealth = (specimen.health/@totalHealth)*100
            if(tempGen.length<@GenrationSize)
                ##you get the first one free
                tempGen.push(angular.extend({},specimen))
                for i in [1..specimen.relativeHealth]
                    if(tempGen.length<@GenrationSize)
                        tempGen.push(angular.extend({},specimen))
        @generation = tempGen

    _mutate:()->
        recordcount = (@PercentOfRecordsToMutate/100) * @GenrationSize
        for i in [1..recordcount]
            RandomPlaylistIndex = Math.floor(Math.random() * @generation.length)
            chosenPlaylist = @generation[RandomPlaylistIndex]
            MutationCount = (@PercentageLevelOfMutation/100)*chosenPlaylist.pool.length
            for j in [1..MutationCount]
                randomIndex1 = Math.floor(Math.random() * @inputList.length)
                randomIndex2 = Math.floor(Math.random() * @inputList.length)
                temporaryValue = chosenPlaylist[randomIndex1]
                chosenPlaylist[randomIndex1] = chosenPlaylist[randomIndex2]
                chosenPlaylist[randomIndex2] = temporaryValue


    _checkHealth:(array)->
        runningHealth = 50
        for i in [0..array.length-1]
            current = array[i]
            ###Check Previous ###
            if(i!=0)
                runningHealth = runningHealth + @_getHealthAtDepth(array,i,2,1)
            ###Check 2 ago ###
            if(i>=2)
                runningHealth = runningHealth + @_getHealthAtDepth(array,i,1,2)
            ###Check 3 ago ###
            if(i>=3)
                runningHealth = runningHealth + @_getHealthAtDepth(array,i,.5,3)
            if(i>=4)
                runningHealth = runningHealth + @_getHealthAtDepth(array,i,.2,4)
            if(i>=5)
                runningHealth = runningHealth + @_getHealthAtDepth(array,i,.1,5)
            if(i>=6)
                runningHealth = runningHealth + @_getHealthAtDepth(array,i,.05,6)
            if(i>=7)
                runningHealth = runningHealth + @_getHealthAtDepth(array,i,.01,7)
            if(i>=8)
                runningHealth = runningHealth + @_getHealthAtDepth(array,i,.001,8)
        return runningHealth

    _getHealthAtDepth:(array, index, mulitplier, depth)->
        runningHealth = 0
        previous =array[index-depth]
        current = array[index]
        ### Band Name ###
        if(previous.BandName!=null && current.BandName!=null && previous.BandName == current.BandName)
            runningHealth= runningHealth-(10* mulitplier)
        ### Tags:Rap ###
        if(current.Tags.Rap && previous.Tags.Rap)
            runningHealth= runningHealth-(2* mulitplier)
        ### Tags:Metal ###
        if(current.Tags.Metal && previous.Tags.Metal)
            runningHealth= runningHealth-(2* mulitplier)
        ### Tags:Foreign ###
        if(current.Tags.Foreign && previous.Tags.Foreign)
            runningHealth= runningHealth-(2* mulitplier)
        ### Tags:Spoof ###
        if(current.Tags.Spoof && previous.Tags.Spoof)
            runningHealth= runningHealth-(2* mulitplier)
        ### Tags:FiveStar ###
        if(current.Tags.FiveStar && previous.Tags.FiveStar)
            runningHealth= runningHealth-(2* mulitplier)
        ### Tags:Halloween ###
        if(current.Tags.FiveStar && previous.Tags.Halloween)
            runningHealth= runningHealth-(2* mulitplier)
        return runningHealth

    ##_NextGen:()->
    _GetBest:(arr)->
        arr.sort((a,b)->
            return b.health-a.health
        )
        console.log("Best Individual: "+ arr[0].health)
        console.log("Total Health: "+ @totalHealth)
        return arr[0].pool



