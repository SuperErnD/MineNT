return {
    bind = function()
      local screen = component.list('screen')()
      return component.gpu.bind(screen)
    end,
    available = function()
      local gpu, screen = component.list('gpu')(), component.list('screen')()
      return (gpu and screen)
    end,
    copy = component.gpu.copy,
    getResolution = component.gpu.getResolution,
    setResolution = component.gpu.setResolution,
    getDepth = component.gpu.maxDepth,
    setBG = component.gpu.setBackground,
    setFG = component.gpu.setForeground,
    fill = function(x, y, w, h)
      return component.gpu.fill(x, y, w, h, ' ')
    end,
    fillc = component.gpu.fill,
    drawText = component.gpu.set,
}