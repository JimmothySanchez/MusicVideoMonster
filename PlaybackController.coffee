app = angular.module('Monster-App',['dndLists'])
{ipcRenderer} = require('electron')

app.controller('PlaybackController',($scope)->

    fs = require("fs")
    $scope.selectedVideo = null
    $scope.playingVideo = null
    $scope.PlayList = []
    $scope.fileList =[]
    $scope.Test = "This is stills a test"

    $scope.fullScreen = ()->
        ipcRenderer.send('video-param', JSON.parse('{"fullscreen":true}'))

    $scope.Clearlist= ()->
         $scope.PlayList = []

    $scope.addRecord = (path)->
        filename = path.split('/').pop()
        arrnames = filename.split(' - ')
        bandname = arrnames[0]
        if(arrnames.length>1)
            songname = arrnames[1]
        tempRecord = {"SongName":songname,"BandName" :bandname,"Path":path,"selected":false}
        $scope.PlayList.push(tempRecord)

    $scope.loadfileList = ()->
        $scope.Clearlist()
        ##$scope.fileList.push({"Name":i,"Path":i}) for i in [1..10]
        fs.readdir('G:\\Projects\\YoutubeDownload', (err, dir) =>
            angular.forEach(dir, (value,key)->
                $scope.addRecord(value);
            )
            $scope.$apply();
        )

    $scope.genSort=()->
        gen = new GeneticSort($scope.PlayList)
        $scope.PlayList=[]
        $scope.PlayList = gen.GetSortedArray()
        console.log($scope.PlayList)

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
    

    $scope.manualpush = ()->
        $scope.fileList.push('yo')

    $scope.PlayVideo = (video)->
        console.log(video)
        ipcRenderer.send('stage-video', video)
        $scope.playingVideo = video

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
        nextvideo =  $scope.PlayList[$scope.PlayList.indexOf($scope.playingVideo)+1]
        ipcRenderer.send('stage-video', nextvideo)
        $scope.playingVideo = nextvideo

    ipcRenderer.on('request-video', (event, arg) =>
        $scope.playNext()
    )
)