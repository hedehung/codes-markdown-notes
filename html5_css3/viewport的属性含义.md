#viewport

1. width=device-width 告诉浏览器页面的宽度应该等于设备宽度.
2. initial-scale 放大系数.
3. user-scalable=[no|yes] 是否禁用用户缩放.
4. maximum-scale,minimum-scale 具体缩放的范围值

一半都不禁止用户缩放，响应式设计里面，缩放参数都取1，避免宽页面被缩小看不清楚，因为RWD的设计会调整布局，使得在移动设备上具备良好的表现，RWD中的viewport最终的结果:

```
<meta name="viewport" content="width=device-width,initial-scale=1.0" />
```