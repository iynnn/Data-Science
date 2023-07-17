// 1. Menddefinisi batasan kota kabupaten di Indonesia

var kota = ee.FeatureCollection("FAO/GAUL/2015/level2")
var indo = kota.filter(ee.Filter.eq('ADM0_NAME', 'Indonesia'));
var province = kota.filter(ee.Filter.eq('ADM1_NAME', 'Dki Jakarta'));

var dataset2 = ee.ImageCollection("COPERNICUS/S5P/NRTI/L3_SO2")
  .select("SO2_column_number_density")
  .filterBounds(indo);

// var test = indo.propertyNames();
var List = [];
for (var i = 0; i < 443; i++) {
  var list= [];
  var test = ee.Feature(indo.toList(443).get(i))
  list.push(test.get('ADM1_NAME'));
  list.push(test.get('ADM2_NAME'));
  
  // var meanImage = dataset2.filterDate('2018-12-01','2018-12-31').reduce(ee.Reducer.mean());
  
  // var meanValue = meanImage.reduceRegion({
  //   reducer: ee.Reducer.mean(),
  //   geometry: kota.filter(ee.Filter.eq('ADM2_NAME',test.get('ADM2_NAME'))),
  //   scale: 1000, // Adjust the scale according to your requirements
  //   maxPixels: 1e9 // Adjust the maximum number of pixels according to your requirements
  // });
  // list.push(meanValue.get('NO2_column_number_density_mean'));

  // var meanImage = dataset2.filterDate('2019-12-01','2019-12-31').reduce(ee.Reducer.mean());
  
  // var meanValue = meanImage.reduceRegion({
  //   reducer: ee.Reducer.mean(),
  //   geometry: kota.filter(ee.Filter.eq('ADM2_NAME',test.get('ADM2_NAME'))),
  //   scale: 1000, // Adjust the scale according to your requirements
  //   maxPixels: 1e9 // Adjust the maximum number of pixels according to your requirements
  // });
  // list.push(meanValue.get('NO2_column_number_density_mean'));
  
  var meanImage = dataset2.filterDate('2020-12-01','2020-12-31').reduce(ee.Reducer.mean());
  
  var meanValue = meanImage.reduceRegion({
    reducer: ee.Reducer.mean(),
    geometry: kota.filter(ee.Filter.eq('ADM2_NAME',test.get('ADM2_NAME'))),
    scale: 1000, // Adjust the scale according to your requirements
    maxPixels: 1e9 // Adjust the maximum number of pixels according to your requirements
  });
  list.push(meanValue.get('SO2_column_number_density_mean'));
  
  // var meanImage = dataset2.filterDate('2021-12-01','2021-12-31').reduce(ee.Reducer.mean());
  
  // var meanValue = meanImage.reduceRegion({
  //   reducer: ee.Reducer.mean(),
  //   geometry: kota.filter(ee.Filter.eq('ADM2_NAME',test.get('ADM2_NAME'))),
  //   scale: 1000, // Adjust the scale according to your requirements
  //   maxPixels: 1e9 // Adjust the maximum number of pixels according to your requirements
  // });
  // list.push(meanValue.get('NO2_column_number_density_mean'));
  
  // var meanImage = dataset2.filterDate('2022-12-01','2022-12-31').reduce(ee.Reducer.mean());
  
  // var meanValue = meanImage.reduceRegion({
  //   reducer: ee.Reducer.mean(),
  //   geometry: kota.filter(ee.Filter.eq('ADM2_NAME',test.get('ADM2_NAME'))),
  //   scale: 1000, // Adjust the scale according to your requirements
  //   maxPixels: 1e9 // Adjust the maximum number of pixels according to your requirements
  // });
  // list.push(meanValue.get('NO2_column_number_density_mean'));
  
  // var meanImage = dataset2.filterDate('2023-01-01','2023-12-31').reduce(ee.Reducer.mean());
  
  // var meanValue = meanImage.reduceRegion({
  //   reducer: ee.Reducer.mean(),
  //   geometry: kota.filter(ee.Filter.eq('ADM2_NAME',test.get('ADM2_NAME'))),
  //   scale: 1000, // Adjust the scale according to your requirements
  //   maxPixels: 1e9 // Adjust the maximum number of pixels according to your requirements
  // });
  // list.push(meanValue.get('NO2_column_number_density_mean'));
  
  List.push(list)
}

// print(List)

// Create a feature collection from the list
var featureCollection = ee.FeatureCollection(List.map(function(value, index){
  var feature = ee.Feature(null, {'Value': value});
  return feature.set('Index', index);
}));

// Export the feature collection to Google Drive as a CSV file
Export.table.toDrive({
  collection: featureCollection,
  description: 'my_list_export',
  fileFormat: 'CSV'
});
// print(indo.size())
// var test = ee.Feature(indo.toList(4).get(0))
// print(test.get('ADM2_NAME'));

// print(indo.get(1))
// for (i in n){
//   print(i)
// }