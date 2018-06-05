时间：2018/1/3 20:50:42   
参考 ：

1. [GeoJSON](https://en.wikipedia.org/wiki/GeoJSON)
2. [rfc7946](https://tools.ietf.org/html/rfc7946)  

## GeoJson  
用于表达地理空间特征的JSON数据。

几何类型（大小写敏感）：

* Point： the "coordinates" member is a single position.
* MultiPoint：the "coordinates" member is an array of positions.
* LineString：the "coordinates" member is an array of two or more positions.
* MultiLineString：the "coordinates" member is an array of LineString coordinate arrays.
* Polygon：闭合，中间可以有孔（多边形嵌套一个多边形，两个多边形之间的内容）
* MultiPolygon：the "coordinates" member is an array of Polygon coordinate arrays.
* GeometryCollection

GeoJson类型，包含上面七个（大小写敏感），以及：

* Feature ：代表空间有限的事物
* FeatureCollection

## 示例  

### 几何图形（Geometry）  
#### Points 点

Point coordinates are in x, y order (easting, northing for projected coordinates, longitude, and latitude for geographic coordinates):

	{
		"type": "Point",
		"coordinates": [100.0, 0.0]
	}
#### LineStrings 线，点的集合  
Coordinates of LineString are an array of positions.

	{
	  "type": "LineString",
	  "coordinates": [
	    [100.0, 0.0],
	    [101.0, 1.0]
	  ]
	}
#### Polygons 多边形  
* 无孔多边形：

	     {
	         "type": "Polygon",
	         "coordinates": [
	             [
	                 [100.0, 0.0],
	                 [101.0, 0.0],
	                 [101.0, 1.0],
	                 [100.0, 1.0],
	                 [100.0, 0.0]
	             ]
	         ]
	     }
* 嵌套多边形  

	     {
	         "type": "Polygon",
	         "coordinates": [
	             [
	                 [100.0, 0.0],
	                 [101.0, 0.0],
	                 [101.0, 1.0],
	                 [100.0, 1.0],
	                 [100.0, 0.0]
	             ],
	             [
	                 [100.8, 0.8],
	                 [100.8, 0.2],
	                 [100.2, 0.2],
	                 [100.2, 0.8],
	                 [100.8, 0.8]
	             ]
	         ]
	     }


#### MultiPoints 多个点    

     {
         "type": "MultiPoint",
         "coordinates": [
             [100.0, 0.0],
             [101.0, 1.0]
         ]
     }

#### MultiPolygons 多个多边形   

     {
         "type": "MultiPolygon",
         "coordinates": [
             [
                 [
                     [102.0, 2.0],
                     [103.0, 2.0],
                     [103.0, 3.0],
                     [102.0, 3.0],
                     [102.0, 2.0]
                 ]
             ],
             [
                 [
                     [100.0, 0.0],
                     [101.0, 0.0],
                     [101.0, 1.0],
                     [100.0, 1.0],
                     [100.0, 0.0]
                 ],
                 [
                     [100.2, 0.2],
                     [100.2, 0.8],
                     [100.8, 0.8],
                     [100.8, 0.2],
                     [100.2, 0.2]
                 ]
             ]
         ]
     }
####  MultiLineStrings 多条线    

     {
         "type": "MultiLineString",
         "coordinates": [
             [
                 [100.0, 0.0],
                 [101.0, 1.0]
             ],
             [
                 [102.0, 2.0],
                 [103.0, 3.0]
             ]
         ]
     }

#### GeometryCollections 几何图形集合

	{
         "type": "GeometryCollection",
         "geometries": [
			{
             "type": "Point",
             "coordinates": [100.0, 0.0]
         	},
			{
             "type": "LineString",
             "coordinates": [
                 [101.0, 0.0],
                 [102.0, 1.0]
             ]
         }]
     }

###  FeatureCollection 特征集合

	{
	  "type": "FeatureCollection",
	  "features": [
	    {
	      "type": "Feature",
	      "geometry": {
	        "type": "Point",
	        "coordinates": [102.0, 0.5]
	      },
	      "properties": {
	        "prop0": "value0"
	      }
	    },
	    {
	      "type": "Feature",
	      "geometry": {
	        "type": "LineString",
	        "coordinates": [
	          [102.0, 0.0],
	          [103.0, 1.0],
	          [104.0, 0.0],
	          [105.0, 1.0]
	        ]
	      },
	      "properties": {
	        "prop0": "value0",
	        "prop1": 0.0
	      }
	    },
	    {
	      "type": "Feature",
	      "geometry": {
	        "type": "Polygon",
	        "coordinates": [
	          [
	            [100.0, 0.0],
	            [101.0, 0.0],
	            [101.0, 1.0],
	            [100.0, 1.0],
	            [100.0, 0.0]
	          ]
	        ]
	      },
	      "properties": {
	        "prop0": "value0",
	        "prop1": {
	          "this": "that"
	        }
	      }
	    }
	  ]
	}
