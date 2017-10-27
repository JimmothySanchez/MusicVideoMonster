app = angular.module('Monster-App',['dndLists'])
{ipcRenderer} = require('electron')

app.controller('PlaybackController',($scope)->

    fs = require("fs")
    $scope.selectedVideo = null
    $scope.playingVideo = null
    ##$scope.PlayList = []
    $scope.fileList =[]
    $scope.Test = "This is stills a test"
    seriously = new Seriously()

    $scope.fullScreen = ()->
        ipcRenderer.send('video-param', JSON.parse('{"fullscreen":true}'))

    $scope.Clearlist= ()->
         $scope.fileList = []

    $scope.ClearSelected = ()->
        $scope.selectedVideo = null
        for video in $scope.fileList
            video.selected = false

    $scope.addRecord = (path)->
        filename = path.split('/').pop()
        arrnames = filename.split(' - ')
        bandname = arrnames[0]
        if(arrnames.length>1)
            songname = arrnames[1]
        tempRecord = 
            SongName:songname
            BandName :bandname
            Path:path
            selected:false
            Tags:
                Rap: false
                Metal: false
                Foreign: false
                Spoof:false
                FiveStar: false
                Halloween:false

        $scope.fileList.push(tempRecord)

    $scope.loadFromdirectory = ()->
        $scope.Clearlist()
        ##$scope.fileList.push({"Name":i,"Path":i}) for i in [1..10]
        fs.readdir('G:\\Projects\\YoutubeDownload', (err, dir) =>
            angular.forEach(dir, (value,key)->
                $scope.addRecord(value);
            )
            $scope.$apply();
        )
    $scope.RemoveSelectedRecord = ()->
        $scope.fileList.pop($scope.selectedVideo)
        index = $scope.fileList.indexOf($scope.selectedVideo)
        if(index>-1)
            $scope.fileList.splice(index,1)
            $scope.selectedVideo = null

    $scope.loadFromJSON = ()->
        console.log('start')
        fs.readFile('MonsterSave.txt', 'utf-8', (err, data) => 
            if(err)
                alert("Whit went wrong: "+ err.message)
                return
            $scope.Clearlist()
            templist = JSON.parse(data)
            console.log(templist)
            $scope.ClearSelected()
            $scope.fileList = templist
            $scope.$apply()
        )

    $scope.genSort=()->
        gen = new GeneticSort($scope.fileList)
        $scope.ClearSelected()
        $scope.fileList=[]
        $scope.fileList = gen.GetSortedArray()

        console.log($scope.fileList)

    $scope.selectRecord = (file)->
        if($scope.selectedVideo !=null)
            $scope.selectedVideo.selected = false
        $scope.selectedVideo = file
        file.selected = true

    $scope.sendEffect = (name)->
        param = 
            effect:
                type:name
        ipcRenderer.send('video-param',param)

    $scope.scanEffect = ()->
        vignette =seriously.effect("vignette")
        console.log(seriously)
        console.log(vignette.inputs())
        ###fs.readFile('lib/effects/seriously.checkerboard.js', 'utf-8', (err, data) => 
            if(err)
                alert("What went wrong: "+ err.message)
                return
            console.log(data)
            tempEffect = JSON.parse(data)
            console.log(tempEffect)
        ) ###

    updatePlayingVieoUI = (video)->
        if($scope.playingVideo)
            $scope.playingVideo.playing = null
        $scope.playingVideo = video
        $scope.playingVideo.playing = true

    $scope.PlayVideo = (video)->
        console.log(video)
        ipcRenderer.send('stage-video', video)
        updatePlayingVieoUI(video)

    $scope.test =()->
        console.log('test')

    $scope.save=()->
        try
            fs.writeFileSync('MonsterSave.txt', angular.toJson($scope.fileList, true), 'utf-8')
        catch e
            console.log(e)
            alert('Failed to save the file !')

    $scope.playNext=()->
        console.log('vieo over')
        nextvideo =  $scope.fileList[$scope.fileList.indexOf($scope.playingVideo)+1]
        ipcRenderer.send('stage-video', nextvideo)
        updatePlayingVieoUI(nextvideo)

    ipcRenderer.on('request-video', (event, arg) =>
        $scope.playNext()
    )
)