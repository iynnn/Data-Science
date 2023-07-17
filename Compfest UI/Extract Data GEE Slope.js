
var jak = boun.filter(ee.Filter.eq('ADM1_NAME', 'Jakarta'));

// A digital elevation model.
var dem = ee.Image('NASA/NASADEM_HGT/001').select('elevation');

// Calculate slope. Units are degrees, range is [0,90).
var slope = ee.Terrain.slope(dem);
var slope_min ={min: 0, max: 10};



// // Crop Nighttime Data and Visualize It
Map.centerObject(jakarta_bersih, 10);

var slct_jkt = slope.clip(jakarta_bersih);
Map.addLayer(slct_jkt, slope_min, 'Slope');


// REDUCER SLOPE
var reduced_slope = slct_jkt.reduceRegions({
  collection: jakarta_bersih,
  reducer: ee.Reducer.mean(),
  scale: 100,
});

// Export to CSV SLOPE
Export.table.toDrive({
  collection: reduced_slope,
  description: 'SLOPE di Jakara',
  fileFormat: 'CSV',
  folder: 'content/drive/MyDrive/[01]Kelass/3SD1/Smt 6/Teknologi Big Data/Project UTS/'
});


// // Export to Visualisasi SLOPE
var SLOPE_jkt = slope.clip(jakarta_bersih);
Export.image.toDrive({
  image: SLOPE_jkt,
  description: 'SLOPE',
  region: jakarta_bersih,
  scale : 100,
  folder: 'content/drive/MyDrive/[01]Kelass/3SD1/Smt 6/Teknologi Big Data/Project UTS/',
  maxPixels: 1e9
});


var dataset = ee.Image('CGIAR/SRTM90_V4');
var elevation = dataset.select('elevation');
var slope = ee.Terrain.slope(elevation);