时间 : 2016/6/28 10:09:51 

## 说明

> `Text overflow` can only happen on block or inline-block level elements, because the element needs to have a width in order to be overflow-ed. The overflow happens in the direction as determined by the direction property or related attributes.

> `Text overflow` 使用的元素表须有宽度

## 用在 `li`

    li{
        overflow: hidden;
        white-space: nowrap;
        text-overflow:ellipsis; 
        width: 747px;
    }

## 用在 `a`

    a{
        overflow: hidden;
        white-space: nowrap;
        text-overflow:ellipsis; 
        width: 747px;
        display: inline-block;
    }