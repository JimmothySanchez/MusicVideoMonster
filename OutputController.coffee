$(document).ready(()->

    ###Global Vars###
    video1 = $('#video1')
    video2 = $('#video2')
    canvas = $('#canvas')
    seriously = new Seriously()
    reformat = seriously.transform('reformat')
    vignette = seriously.effect("vignette")
    tvGlitch = null
    blend = seriously.effect('blend')
    {ipcRenderer} = require('electron')
    effectList = []
    
    ###Runtime flags ###
    clock = 0
    activeVideoIndex = 0
    inTransition = false
    transitionStartTime = 0
    glitchOn = false
    durationCheck = false

    ##Static Defaults
    fadeOutTime = 5000
    tickInterval = 100

    effectPlugins = {}
    currentEffect=null



    debug = ()->
        abspath = 'G:\\Projects\\YoutubeDownload\\'
        $("#opacity").on('input',()->
           ## blend.opacity = $("#opacity").val()
        )
        video1[0].src = abspath+'Alex Gaudino feat. Crystal Waters - Destination Calabria [Explicit Version] [Official Video].mp4'
        video1[0].load()
        video1[0].addEventListener("canplaythrough",()->
            @play()
        )
        video2[0].src = abspath+'Major Lazer – Light it Up (feat. Nyla & Fuse ODG) [Music Video Remix] by Method Studios.mp4'
        video2[0].load()
        video2[0].addEventListener("canplaythrough",()->
            @play()
        )
        video1[0].volume=0
        video2[0].volume=0
        transitionStartTime = clock
        activeVideoIndex =2
        inTransition = true

    setUpEffectPlugins = (inNode,outNode)->
        initEffect("ascii")
        initEffect("hex")
        initEffect("invert")
        initEffect("sketch")
        initEffect("kaleidoscope")
        initEffect("nightvision")

        pluginParams =[]
        for plugin in effectPlugins
            pluginParams.push(
                Name: plugin.effect
                Params: plugin.inputs()
            )
        ipcRenderer.send('effect-params', pluginParams)     

    initEffect = (effectName)->
        temp = seriously.effect(effectName)
        effectPlugins[temp.effect] = temp
        ##effectPlugins.push(temp)
        ##temp.on(temp.effect+'-on')
        ##temp.off((temp.effect+'-off'))
        temp.source = blend
        return temp

    init = ()->
        video1[0].playbackRate = 1
        video2[0].playbackRate = 1
        target = seriously.target('#canvas')
        reformat.width = target.width
        reformat.height = target.height
        reformat.mode = 'cover'
        #reformat.source = seriously.source('#video1')
        blend.bottom = seriously.source('#video1')
        blend.top = seriously.source('#video2')

        setUpEffectPlugins(vignette,reformat)
        vignette.source = blend
        target.source = reformat;
        reformat.source = vignette
        seriously.go()
        
        window.setInterval(onTick,tickInterval)
        setTimeout(startGlitch, 10000+Math.random()*60000)

    $('#btnFullscreen').click(()->
        canvas[0].webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT)
    )

    $('#video').on("timeupdate",()->
        dostuff =1
    )

    ipcRenderer.on('video-load', (event, arg) => 
        abspath = 'G:\\Projects\\YoutubeDownload\\' + arg.Path
        video1[0].src = abspath
        video1[0].load()
        video1[0].addEventListener("canplaythrough",()->
            @play()
        )
    )

    ipcRenderer.on('pause-playback', (event, arg) => 
        console.log('pause')
        if(activeVideoIndex ==1)
            video1[0].pause()
        else
            video2[0].pause()
    )

    ipcRenderer.on('play', (event, arg) => 
        console.log('pause')
        if(activeVideoIndex ==1)
            video1[0].play()
        else
            video2[0].play()
    )

    ipcRenderer.on('stage-video', (event, arg) => 
        console.log('staging')
        transitionWindow()
        abspath = 'G:\\Projects\\YoutubeDownload\\' + arg.Path
        if(activeVideoIndex ==1)
            video1[0].src = abspath
            video1[0].load()
            video1[0].addEventListener("canplaythrough",()->
                @play()
                durationCheck = true
            )
        else
            video2[0].src = abspath
            video2[0].load()
            video2[0].addEventListener("canplaythrough",()->
                @play()
                durationCheck = true
            )
    )

    ipcRenderer.on('change-effect', (event, arg) => 
        console.log(arg)
        if(arg.Name == 'None')
            currentEffect = null
            vignette.source=blend
        else
            if(currentEffect ==null || currentEffect.effect != arg.Name)
                currentEffect = effectPlugins[arg.Name]
                vignette.source = currentEffect
            if(arg.field)
                currentEffect[arg.field] = arg.value
    )

    checkDurationContitions=()->
        if(durationCheck)
            if(activeVideoIndex ==1)
                if(video1[0].duration-video1[0].currentTime<=fadeOutTime/1000)
                    ipcRenderer.send('request-video', true)
                    durationCheck = false
            else
                if(video2[0].duration-video2[0].currentTime<=fadeOutTime/1000)
                    ipcRenderer.send('request-video', true)
                    durationCheck = false

    startGlitch=()->
        tvGlitch = seriously.effect('tvglitch')
        tvGlitch.source =vignette
        setTimeout(endGlitch, Math.random()*1000)

    endGlitch=()->
        reformat.source = vignette
        tvGlitch.destroy()
        tvGlitch = null
        setTimeout(startGlitch, 10000+Math.random()*60000)

    transitionWindow = ()->
        inTransition = true
        transitionStartTime = clock
        if(activeVideoIndex == 1)
            activeVideoIndex = 2
        else
            activeVideoIndex = 1

    onTick = ()->
        clock = clock+tickInterval
        if(inTransition)
            updateTransitions()
        updateVignette()
        checkDurationContitions()

    updateVignette=()->
        vignette.amount = 1+2*Math.sin(clock/12000)+Math.random()/2

    updateTransitions=()->
        currentDuration = clock-transitionStartTime
        if(currentDuration>=fadeOutTime)
            if(activeVideoIndex ==1)
                blend.opacity = 0
                video1[0].volume=1
                video2[0].volume=0
            else
                blend.opacity =1
                video1[0].volume=0
                video2[0].volume=1
            blend.inTransition = false
        else
            alpha =(clock-transitionStartTime)/fadeOutTime
            if(activeVideoIndex ==1)
                blend.opacity = 1-alpha
                video1[0].volume=alpha
                video2[0].volume=1-alpha
            else
                blend.opacity =alpha
                video1[0].volume=1-alpha
                video2[0].volume=alpha

    init()
    ##debug()
)
