<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:77vh;overflow:hidden">
  	<div class="visualize_widget" class="nav-tabs-custom">
	</div>
	<div id="divtoshow" style="position: fixed;display:none;">test</div>
	<div id="chartTab">
  </div>
<div class="menu" id="menu">
 <ul>
 <a id="append" href="#"><li>Add to Search</li></a>
 <a id="replace" href="#"><li>Search for</li></a>
 <a id="coauthors" href="#"><li>Add Co-Authors</li></a>
 </ul>
</div>
</div>
 	
<style>
#tab_network {
	  height: 50vh;
	  position: relative;
}    
#canvas {
      color: #fff;
      background: #fff;
	  position: absolute;
	  width:97%;
	  height: 80%;
}
.label {
      position: absolute;
      top: 10px;
      left: 10px;
      z-index: 1;
      font-family: sans-serif;
    }
svg .tooltip { 
	opacity: 1; 
}   
#chartTab{
	height: 68vh;
	font-size: 2px;
}   
#svgContainer{
	font-size: 10px;
}
g.arc path {
}
.venntooltip {
	position: absolute;
  	text-align: center;
  	width: 70px;
  	height: 24px;
  	background: #333;
  	color: #ddd;
  	padding: 2px;
  	border: 0px;
  	border-radius: 8px;
  	opacity: 0;
}
#divtoshow	{
	background-color:Black;
  	color:White;
  	font-weight:normal;
  	padding: 2px;
  	border: 0px;
  	border-radius: 0.5em;
  	z-index: 100;
}
.menu 	{
	width: 100px;
	position:absolute;
	display: none;
	box-shadow: 0 0 10px #713C3C;
	z-index: 100;
}
.menu ul	{
	list-style: none;
	padding: 0;
	margin:0;
}
.menu ul li	{
	padding: 6%;
	background: #000;
	color: #fff;
}
.menu ul li:hover	{
	background-color: #F7BA4B;
   	color: #444343;
}
</style>

<script>

		
<#-- jquery -->
$( function(){
		var visType = "";
		var defaultVisType = "";
		var objectType = "";
		var visList = [];
		<#-- do not load data again if already loaded -->
		var loadedList = [];
		var dataLoadedFlag = "0";
		var loadedLoc = [];
		var graphFile;
		var options ={
			source : "<@spring.url '/explore/visualize' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				
						},
			onRefreshDone: function(  widgetElem , data ){
				loadedList = [];
				graphFile = "";
				names = data.dataList;
				ids = data.idsList;
				yearFilterPresent = data.yearFilterPresent;
				deleteFlag = data.deleteFlag;
				var targetContainer = $( widgetElem ).find( ".visualize_widget" );
				
				targetContainer.html("");			
				hidehoverdiv('divtoshow');
				hidemenudiv('menu')

				<#-- update type of visualization depending on selection-->
				if(objectType == ""){
					objectType = data.type;
					visType = data.visType;
				}
				if(data.type!==objectType){
					objectType = data.type;
					visType = data.visType;
				}
				if(data.type==objectType && visType!=data.visType && data.visType!=""){
					visType = data.visType;
				}
				
			<#-- if more than one item in consideration -->	
			if(ids.length>1)
			{
				if(visType=="researchers"){
					visList = ["Network", "Group", "List", "Comparison"];
					if(objectType=="researcher")
					{
						visList = ["Network", "Group", "Similar", "List", "Comparison"];
					}
				}
				if(visType=="conferences"){
					visList = ["Locations", "Group", "List", "Comparison"];
					if(objectType=="conference")
					{
						visList = ["Locations", "Similar", "List"]; //comparison doesn't make sense here
					}
					if(objectType=="publication")
					{
						visList = ["Locations", "List"]; //comparison doesn't make sense here
					}
				}		
				if(visType=="publications"){
					if(objectType!="conference")
						visList = ["Timeline", "Group", "List", "Comparison"];
					if(objectType=="publication")
					{
						visList = ["Timeline", "Group", "Similar", "List"];
					}	
				}
				if(visType=="topics"){
					visList = ["Bubbles", "Evolution", "List", "Comparison"];
				}
			}
			else
			{
				if(visType=="researchers"){
					visList = ["Network", "Group", "List"];
					if(objectType=="researcher")
					{
						visList = ["Network", "Group", "Similar", "List"];
					}
				}
				if(visType=="conferences"){
					visList = ["Locations", "Group", "List"];
					if(objectType=="conference")
					{
						visList = ["Locations", "Similar", "List"];
					}
				}		
				if(visType=="publications"){
					visList = ["Timeline", "Group", "List"];
					if(objectType=="publication")
					{
						visList = ["Timeline", "Group", "Similar", "List"];
					}	
				}
				if(visType=="topics"){
					visList = ["Bubbles", "Evolution", "List"];
				}
			}	
				<#-- create tabs according to visualization type-->
				var visualizationTabs = $( '<div/>' )
													.attr({"id":"tab_visualization"})
													.addClass( "nav-tabs-custom" )

				var visualizationTabsHeaders = $( '<ul/>' )
													.addClass( "nav nav-tabs" );
				 visualizationTabsContents = $( '<div/>' )
													.addClass( "tab-content" );

				<#-- append tab header and content -->
				visualizationTabs.append( visualizationTabsHeaders ).append( visualizationTabsContents );

				if(ids.length!=0)
					<#-- set inner tab into main tab -->
					{targetContainer.html( visualizationTabs );}

				<#-- fill with types from visList -->
				$.each( visList , function( index, item ){
					<#-- tab header -->
					var tabHeaderText = item;

					<#-- tab content -->
					var tabContent = $( '<div/>' )
						.attr({ "id" : "tab_" + tabHeaderText })
						.addClass( "tab-pane" )
						//.css("height","70vh")
						//.css("overflow","scroll");
					
					var tabHeader = $( '<li/>' )
						.append(
							$( '<a/>' )
							.attr({ "href": "#tab_" + tabHeaderText, "data-toggle":"tab" , "aria-expanded" : "true", "title" : tabHeaderText})
							.html( tabHeaderText )
						);
						
				 	tabHeader.on("click",function(e){
				 		hidehoverdiv('divtoshow');
				 		hidemenudiv('menu')
						loadVis(data.type, visType, e.target.title, widgetElem, names, ids, tabContent, data.authoridForCoAuthors);
					});

					if( index == 0 ){
						tabHeader.addClass( "active" );
						tabContent.addClass( "active" );
					}
					

					<#-- append tab header and content -->
					visualizationTabsHeaders.append( tabHeader );
					visualizationTabsContents.append( tabContent );

					if(item == visList[0]){
						loadVis(data.type, visType, item, widgetElem, names, ids, tabContent, data.authoridForCoAuthors);
					}
				});
				
			}
		};
		
		<#-- load data n visualization only when that tab shows up, not before -->
		function loadVis(type, visType, visItem, widgetElem, names, ids, tabContent, authoridForCoAuthors){
		
				<#-- generate unique id for progress log -->
				var uniqueVisWidget = $.PALM.utility.generateUniqueId();
				
				<#-- to show the gephi network again -->
				if(loadedList.indexOf(visItem)!= -1 && visItem=="Network"){
					var reload="true";
					tabVisNetwork(uniqueVisWidget, url, widgetElem, tabContent, reload);
				}
				if(loadedList.indexOf(visItem)== -1){
				
					<#-- show pop up progress log -->
					$.PALM.popUpMessage.create( "Loading "+visItem, { uniqueId:uniqueVisWidget, popUpHeight:40, directlyRemove:false , polling:false});
					var url = "<@spring.url '/explore/visualize' />"+"?visTab="+visItem+"&type="+type+"&visType="+visType+"&dataList="+names+"&idList="+ids+"&checkedPubValues="+checkedPubValues+"&checkedConfValues="+checkedConfValues+"&checkedTopValues="+checkedTopValues+"&checkedCirValues="+checkedCirValues+"&startYear="+startYear+"&endYear="+endYear+"&yearFilterPresent="+yearFilterPresent+"&deleteFlag="+deleteFlag+"&authoridForCoAuthors="+authoridForCoAuthors;
		
					if(visItem == "Network"){
						tabVisNetwork(uniqueVisWidget, url, widgetElem, tabContent, false);
					}
					if(visItem == "Locations"){
						tabVisLocations(uniqueVisWidget, url, widgetElem, tabContent);
					}
					if(visItem == "Timeline"){
						tabVisTimeline(uniqueVisWidget, url, widgetElem, tabContent);
					}
					if(visItem == "Evolution"){
						tabVisEvolution(uniqueVisWidget, url, widgetElem, tabContent);
					}
					if(visItem == "Bubbles"){
						tabVisBubbles(uniqueVisWidget, url, widgetElem, tabContent);
					}
					if(visItem == "Group"){
						tabVisGroup(uniqueVisWidget, url, widgetElem, tabContent, visType);
					}
					if(visItem == "List"){
						tabVisList(uniqueVisWidget, url, widgetElem, tabContent, visType, type);
					}
					if(visItem == "Comparison"){
						tabVisComparison(uniqueVisWidget, url, widgetElem, tabContent);
					}
					if(visItem == "Similar"){
						tabVisSimilar(uniqueVisWidget, url, widgetElem, tabContent);
					}
				}		
				loadedList.push(visItem);
		}
		
		<#-- NETWORK TAB -->
		function tabVisNetwork(uniqueVisWidget, url, widgetElem, tabContent, reload){
			
			var tabContainer = $( widgetElem ).find( "#tab_Network" );
				
				var canvasDiv = $('<div/>').attr({'id': 'canvas'});
				tabContent.html("");
				tabContent.append(canvasDiv);
			
				<#-- initialize sigma.js renderer for gephi-->
				s = new sigma({
		            renderer: {
		              container: document.getElementById('canvas'),
		              type: 'canvas'
		            },
		            settings: {
		            	labelColor: 'default',
		            	enableEdgeHovering: true,
		            	edgeHoverColor: 'edge',
		            	edgeHoverExtremities: true,
		            	maxEdgeSize: 5,
		            	autoRescale: ['nodeSize'],
		            	maxNodeSize: 4,
		            	doubleClickZoomingRatio: 1.7,
		            	labelThreshold: 6,
		            	zoomMax: 50,
		            	
		            	//defaultHoverLabelBGColor: "pink"
		            }
		        });
		        
			if(reload!="true"){
			$.getJSON( url , function( data ) {
				
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniqueVisWidget );
				
				<#-- gephi network -->
				graphFile=data.map.graphFile;
				sigma.parsers.gexf( "<@spring.url '/resources/gexf/'/>" + data.map.graphFile ,s,function() {
					//s.refresh();
					s.refresh();
					s.graph.nodes().forEach(function(n) {
				        n.originalColor = n.color;
				      });
				      s.graph.edges().forEach(function(e) {
				        e.originalColor = e.color;
				      });
				      
					s.bind('overNode', function(e){
						var nodeId = e.data.node.id,
            			toKeep = s.graph.neighbors(nodeId);
				        toKeep[nodeId] = e.data.node;
				
				        s.graph.nodes().forEach(function(n) {
				          if (toKeep[n.id])
				            n.color = n.originalColor;
				          else
				            n.color = '#eee';
				        });
				
				        s.graph.edges().forEach(function(e) {
				          if (toKeep[e.source] && toKeep[e.target])
				            e.color = e.originalColor;
				          else
				            e.color = '#eee';
				        });
				
				        // Since the data has been modified, we need to
				        // call the refresh method to make the colors
				        // update effective.
				        s.refresh();
					})
					
					s.bind('clickNode', function(e){
						if(e.data.node.attributes.isadded==false){
							var text = e.data.node.label;
							showhoverdiv(e,'divtoshow', text.toUpperCase() + " is currently not present in PALM");
						}
						else
						showmenudiv(e,'menu');
					})
					
					s.bind('overEdge',function(e){
						showhoverdiv(e,'divtoshow', "co-authored " + truncate(e.data.edge.weight / 0.1,0) + " time(s)");
					})
					s.bind('outEdge',function(e){
						hidehoverdiv('divtoshow');
					})
					
					
					s.bind('clickEdge', function(e){
						showmenudiv(e,'menu');
					})
					
					s.bind('clickStage',function(e){
						hidemenudiv('menu');
						hidehoverdiv('divtoshow');
					})
				}); 
				//s.refresh();
				url="";
			});
		}
		else{
		console.log(graphFile)
				<#-- gephi network -->
				sigma.parsers.gexf( "<@spring.url '/resources/gexf/'/>" + graphFile ,s,function() {
					s.refresh();
					s.graph.nodes().forEach(function(n) {
				        n.originalColor = n.color;
				      });
				      s.graph.edges().forEach(function(e) {
				        e.originalColor = e.color;
				      });
				      
					s.bind('overNode', function(e){
						var nodeId = e.data.node.id,
            			toKeep = s.graph.neighbors(nodeId);
				        toKeep[nodeId] = e.data.node;
				
				        s.graph.nodes().forEach(function(n) {
				          if (toKeep[n.id])
				            n.color = n.originalColor;
				          else
				            n.color = '#eee';
				        });
				
				        s.graph.edges().forEach(function(e) {
				          if (toKeep[e.source] && toKeep[e.target])
				            e.color = e.originalColor;
				          else
				            e.color = '#eee';
				        });
				
				        // Since the data has been modified, we need to
				        // call the refresh method to make the colors
				        // update effective.
				        s.refresh();
					})
					s.bind('clickNode', function(e){
						
						if(e.data.node.attributes.isadded==false){
							var text = e.data.node.label;
							showhoverdiv(e,'divtoshow', text.toUpperCase() + " is currently not present in PALM");
						}
						else
						showmenudiv(e,'menu');
					})
					
					s.bind('overEdge',function(e){
						showhoverdiv(e,'divtoshow', "co-authored " + truncate(e.data.edge.weight / 0.1,0) + " time(s)");
					})
					s.bind('outEdge',function(e){
						hidehoverdiv('divtoshow');
					})
					
					
					s.bind('clickEdge', function(e){
						showmenudiv(e,'menu');
					})
					
					s.bind('clickStage',function(e){
						hidemenudiv('menu');
						hidehoverdiv('divtoshow');
					})
					
				}); 
				s.refresh();
				url="";
			}
		}
		
		function truncate (num, places) {
 			 return Math.trunc(num * Math.pow(10, places)) / Math.pow(10, places);
		}
		<#-- neighbour highlight in gephi network -->
		sigma.classes.graph.addMethod('neighbors', function(nodeId) {
    		var k,
	        neighbors = {},
	        index = this.allNeighborsIndex[nodeId] || {};

		    for (k in index)
		      neighbors[k] = this.nodesIndex[k];

    		return neighbors;
  		});
		
		<#-- LOCATIONS TAB -->
		function tabVisLocations(uniqueVisWidget, url, widgetElem, tabContent){
		
		$.getJSON( url , function( data ) {
		
			<#-- remove  pop up progress log -->
			$.PALM.popUpMessage.remove( uniqueVisWidget );
			
			var locDiv = $('<div/>').attr("id","mapid").css("height","60vh").css("z-index","1");
			tabContent.append(locDiv);
				
			mymap = L.map('mapid');
			
			L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
			    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
			    maxZoom: 18,
			    id: 'mguliani.0ph7d97m',
			    accessToken: 'pk.eyJ1IjoibWd1bGlhbmkiLCJhIjoiY2lyNTJ5N3JrMDA1amh5bWNkamhtemN6ciJ9.uBTppyCUU7bF58hUUVxZaw'
			}).addTo(mymap);
			
			var maxlat=0;
			var maxlon=0;
			var minlat=0;
			var minlon=0;
			
			var myLayer;
			var mydata = [];	
			var city = [];
			var country = [];
			var confdata = data;
			var i;
			
			console.log("locations data")
			console.log(data)
			if(data.type=="researcher" || data.type=="publication")
			{
					for(i=0; i< data.map.events.length; i++)
					{
					 (function(i) {
						$.getJSON("https://api.mapbox.com/geocoding/v5/mapbox.places/" + data.map.events[i].location.city + ".json?autocomplete=false&access_token=pk.eyJ1IjoibWd1bGlhbmkiLCJhIjoiY2lyNTJ5N3JrMDA1amh5bWNkamhtemN6ciJ9.uBTppyCUU7bF58hUUVxZaw",
							function(mapdata){
			
								conf = data.map.events[i].groupName // need to check this!!
								year = data.map.events[i].year
								eventGroupId = data.map.events[i].eventGroupId
								groupname = data.map.events[i].groupName
				
								mapdata.features[0].properties.conference = conf
								mapdata.features[0].properties.year = year
								mapdata.features[0].properties.eventGroupId = eventGroupId
								mapdata.features[0].properties.groupname = groupname
								mapdata.features[0].properties.dataType = "researcher"
								mydata.push(myLayer.addData(mapdata.features[0]));
							});
						})(i);
					}			
					myLayer = L.geoJson(mydata, {
						       pointToLayer: function (feature, latlng) {
						      	
						       if(latlng.lat > maxlat){
						       		maxlat = latlng.lat
						       }
						       if(latlng.lat < minlat){
						       		minlat = latlng.lat
						       }
						       if(latlng.lon > maxlon){
						       		maxlon = latlng.lon
						       }
						       if(latlng.lon < minlon){
						       		minlat = latlng.lon
						       }
						       
						        mymap.setView([(maxlat+minlat)/2,(maxlon+minlon)/2], 2);
						         return L.marker(latlng).bindPopup("<b>Hello world!</b><br>I am a popup.").openPopup();
						       },
						       onEachFeature: onEachFeature
						     }).addTo(mymap); 
				}
				if(data.type=="conference")
				{
					var eventGroupList=[];	
					var iconColorList=['green','blue','red','yellow','orange','violet','black','grey'];			
					for(i=0; i< data.map.events.length; i++)
					{
					 (function(i) {
						$.getJSON("https://api.mapbox.com/geocoding/v5/mapbox.places/" + data.map.events[i].location + ".json?autocomplete=false&access_token=pk.eyJ1IjoibWd1bGlhbmkiLCJhIjoiY2lyNTJ5N3JrMDA1amh5bWNkamhtemN6ciJ9.uBTppyCUU7bF58hUUVxZaw",
							function(mapdata){
			
								conf = data.map.events[i].eventGroupName //name
								year = data.map.events[i].year
								eventGroup = data.map.events[i].eventGroupName
								eventGroupId = data.map.events[i].eventGroupId
								if(eventGroupList.indexOf(eventGroup)== -1)
								eventGroupList.push(eventGroup);
								
								mapdata.features[0].properties.conference = conf
								mapdata.features[0].properties.year = year
								mapdata.features[0].properties.eventGroup = eventGroup
								mapdata.features[0].properties.eventGroupId = eventGroupId
								mapdata.features[0].properties.dataType = "conference"
								mydata.push(myLayer.addData(mapdata.features[0]));
							});
						})(i);
					}			
					myLayer = L.geoJson(mydata, {
						       pointToLayer: function (feature, latlng) {
						      	
						       if(latlng.lat > maxlat){
						       		maxlat = latlng.lat
						       }
						       if(latlng.lat < minlat){
						       		minlat = latlng.lat
						       }
						       if(latlng.lon > maxlon){
						       		maxlon = latlng.lon
						       }
						       if(latlng.lon < minlon){
						       		minlat = latlng.lon
						       }
						       
						        mymap.setView([(maxlat+minlat)/2,(maxlon+minlon)/2], 2);
						        return L.marker(latlng,{icon: new L.Icon({
								  iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-'+iconColorList[eventGroupList.indexOf(feature.properties.eventGroup)]+'.png'
								})}).bindPopup("<b>Hello world!</b><br>I am a popup.").openPopup();
						       },
						       onEachFeature: onEachFeature
						     }).addTo(mymap); 
				}
				
				mymap.on('click',function(e){
					hidemenudiv('menu')
					hidehoverdiv('divtoshow')
				})
			});		
		}
		
		function onEachFeature(feature, layer) {
	      var popupContent = feature.properties.conference + ",<br> " + feature.place_name + ",<br> " + feature.properties.year;
	
	      layer.bindPopup(popupContent);
	      
	      layer.on('mouseover', function (e) {
	            this.openPopup();
	        });
	        layer.on('mouseout', function (e) {
	            this.closePopup();
	        });
	      	layer.on('click', function(e){
	      	
	      		obj = {
							type:"clickLocation",
							clientX:e.layerPoint.x,
							clientY:e.layerPoint.y,
							eventGroupId:feature.properties.eventGroupId
						};
	      		
	      		if(feature.properties.dataType == "researcher")
					showmenudiv(obj,'menu');
				if(feature.properties.dataType == "conference")
					showhoverdiv(obj,'divtoshow', "This conference type is already added");
	      	});
    	}
		
		<#-- TIMELINE TAB -->
		function tabVisTimeline(uniqueVisWidget, url, widgetElem, tabContent){
		
		var prevYear = 1000;
		$.getJSON( url , function( data ) {
		
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniqueVisWidget );
				
				var timeDiv = $('<div/>')
							.addClass("timeline")
							.css('overflow-y','scroll')
				
				tabContent.addClass("timeline-body").append(timeDiv);
				
				$(".timeline").slimscroll({
							height: "66vh",
					        size: "5px",
				        	allowPageScroll: true,
				   			touchScrollStep: 50,
				});
				
				var innerTimeDiv = $('<div/>')
				
				timeDiv.append(innerTimeDiv)
				
				var section = innerTimeDiv.append(
					$('<section/>'))
						.attr("id","cd-timeline")
						.addClass("cd-container")
					
				var inner;	
				$.each( data.map.pubDetailsList, function( index, item){
					
						h2=$('<h2/>').css("text-align","center").html(item.year)	
					
						 inner = $('<div/>')
									.addClass("cd-timeline-block")
									.click(function(e){
										hidemenudiv('menu');
									})
						
						if(prevYear!=item.year)
						{			 
						 section.append(h2)
						 prevYear = item.year
						}		
						section.append(inner)
							
						if(item.type=="CONFERENCE")	
						{
									inner.append(
										$('<div/>')
											.addClass("cd-timeline-img cd-conference")
											.attr({ "title" : "Conference" })
											.append(
												$('<img/>')
													.attr("src","<@spring.url '/resources/images/document.svg' />")
											)
									)
						}
						else if(item.type=="JOURNAL")	
						{
									inner.append(
										$('<div/>')
											.addClass("cd-timeline-img cd-journal")
											.attr({ "title" : "Journal" })
											.append(
												$('<img/>')
													.attr("src","<@spring.url '/resources/images/newspaper.svg' />")
											)
									)
						}
						else if(item.type=="WORKSHOP")	
						{
									inner.append(
										$('<div/>')
											.addClass("cd-timeline-img cd-workshop")
											.attr({ "title" : "Workshop" })
											.append(
												$('<img/>')
													.attr("src","<@spring.url '/resources/images/copy.svg' />")
											)
									)
						}
						else if(item.type=="INFORMAL")	
						{
									inner.append(
										$('<div/>')
											.addClass("cd-timeline-img cd-informal")
											.attr({ "title" : "Informal" })
											.append(
												$('<img/>')
													.attr("src","<@spring.url '/resources/images/copy.svg' />")
											)
									)
						}
						else if(item.type=="BOOK")	
						{
									inner.append(
										$('<div/>')
											.addClass("cd-timeline-img cd-book")
											.attr({ "title" : "Book" })
											.append(
												$('<img/>')
													.attr("src","<@spring.url '/resources/images/open-book.svg' />")
											)
									)
						}
						else	
						{
									inner.append(
										$('<div/>')
											.addClass("cd-timeline-img cd-unknown")
											.attr({ "title" : "Unknown" })
											.append(
												$('<img/>')
													.attr("src","<@spring.url '/resources/images/exclamation.svg' />")
											)
									)
						}
						
						inner.append(
								$('<div/>')
									.addClass("cd-timeline-content")
									.append(
										$('<p/>')
										.html(item.title)
										.click(function(e){
												obj = {
														  type:"clickPublication",
												          clientX:e.pageX,
												          clientY:e.pageY,
												          pubId:item.id
												};
												showmenudiv(obj,'menu');
												e.stopPropagation()
										})
										.css("cursor"," pointer")
										
									)
									.append(
										$('<span/>')
										.addClass("cd-date")
										.html(item.year)
									)
						)
				});
			});
		}
		
		<#-- BUBBLES TAB -->
		function tabVisBubbles(uniqueVisWidget, url, widgetElem, tabContent){
			
			$.getJSON( url , function( dataBubble ) {
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniqueVisWidget );
				
				var bubblesTab = $( widgetElem ).find( "#tab_Bubbles" );
				bubblesTab.html("");
				
				visBubbles(dataBubble.map.list);
			});
		}
				
		<#-- EVOLUTION TAB -->
		function tabVisEvolution(uniqueVisWidget, url, widgetElem, tabContent){
			
		$.getJSON( url , function( data ) {
		
		console.log("evolution data")
		console.log(data)
			<#-- remove  pop up progress log -->
			$.PALM.popUpMessage.remove( uniqueVisWidget );
			
			var tabEvolutionContainer = $( widgetElem ).find( "#tab_Evolution" );
			tabEvolutionContainer.html("");
					
			var evolutionSection = $( '<div/>' )
			tabEvolutionContainer.append(evolutionSection);	
			
			var newSect = $( '<div/>' ).attr("id","svgContainer")
			evolutionSection.append(newSect);	
			
							evolutionSection.addClass('evolutionSection')
								.css('overflow-y','scroll')
								.css('max-height','67vh')
							
							$(".evolutionSection").slimscroll({
								height: "67vh",
						        size: "5px",
					        	allowPageScroll: true,
					   			touchScrollStep: 50,
					       });
			
				drawDimpleChart(data.map.list);
			});
		}

		<#-- GROUP TAB -->
		function tabVisGroup(uniqueVisWidget, url, widgetElem, tabContent, visType){
			
			$.getJSON( url , function( data ) {

					<#-- remove  pop up progress log -->
					$.PALM.popUpMessage.remove( uniqueVisWidget );
					var mainWidget = $( widgetElem ).find( "#boxbody-${wUniqueName}" );
					var tabContent1 = $( widgetElem ).find( "#tab-content" );					
					var tabGroupContainer = $( widgetElem ).find( "#tab_Group" );
					tabGroupContainer.html("");
					
					if( data.map == null ){
						$.PALM.callout.generate( tabGroupContainer , "warning", "Empty List!", "Insufficient Data!" );
						return false;
					}
					var groupSection = $( '<div/>' ).addClass("clusters")

					tabContent.append(groupSection);
					
					if(visType == "researchers")
					{
						data = data.map.coauthors;
						if( data == 0 || data == null )
						{
							$.PALM.callout.generate( tabGroupContainer , "warning", "Empty List!", "Insufficient Data!" );
							return false;
						}
						else
							visualizeCluster(data, mainWidget, visType);
					}					
					if(visType == "conferences"){
						data = data.map.conferences;
						visualizeCluster(data, mainWidget, visType);	
					}		
					
					if(visType == "publications"){
						data = data.map.publications;
						console.log(data)
						visualizeCluster(data, mainWidget, visType);	
					}
			});
		}
		
		<#-- LIST TAB -->
		function tabVisList(uniqueVisWidget, url, widgetElem, tabContent, visType, type){
		
		
		
			$.getJSON( url , function( data ) {
						console.log("list data")
						console.log(data)
							var tabListContainer = $( widgetElem ).find( "#tab_List" );
							tabListContainer.html("");	
		  					var listSection = $( '<div/>' );
							tabContent.append(listSection);
							listSection.addClass('_list')
								.css('overflow-y','scroll')
								.css('max-height','67vh')
							
							$("._list").slimscroll({
								height: "74vh",
						        size: "5px",
					        	allowPageScroll: true,
					   			touchScrollStep: 50,
					   			//alwaysVisible: true
					       });
		  					
							<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniqueVisWidget );
							
							if(visType == "researchers")
							{
								if( data.map.count == 0 ){
									$.PALM.callout.generate( tabListContainer , "warning", "Empty List!", "Insufficient Data!" );
									return false;
								}
								
								if( data.map.count > 0 ){
									<#-- build the researcher list -->
									$.each( data.map.coAuthors, function( index, item){
										var researcherDiv = 
										$( '<div/>' )
											.addClass( 'author' )
											.attr({ 'id' : item.id });
										var researcherNav =
										$( '<div/>' )
											.addClass( 'nav' );
										var researcherDetail =
										$( '<div/>' )
											.addClass( 'detail' )
											.append(
												$( '<div/>' )
													.addClass( 'name capitalize' )
													.html( item.name )
											);
										researcherDiv
											.append(
												researcherNav
											).append(
												researcherDetail
											)
											.on('click', function(d){ 
												obj = {
															  type:"listItem",
													          clientX:d.clientX,
													          clientY:d.clientY,
													          itemId:item.id,
													          objectType:"researcher"
													};
														if(item.isAdded)
															showmenudiv(obj, 'menu')
														else
															showhoverdiv(obj, 'divtoshow', item.name.toUpperCase() + " is currently not present in PALM")
											
											});
											
										if( !item.isAdded ){
											researcherDetail.addClass( "text-gray" );
										}
										listSection
											.append( 
												researcherDiv
											);
									});						
								}
							}
							
							if(visType == "conferences")
							{
									var sortedList = data.map.events.sort();
									<#-- build the conference list -->
									$.each( sortedList, function( index, item){
										if(type=="researcher")
										{
											conferenceDiv = 
											$( '<div/>' )
												.addClass( 'author' )
												<#--.attr({ 'id' : item.location.id });-->
										}
										if(type=="conference" || type=="publication")
										{
											conferenceDiv = 
											$( '<div/>' )
												.addClass( 'author' )
												.attr({ 'id' : item.id });
										}
										var conferenceNav =
										$( '<div/>' )
											.addClass( 'nav' )
											.append(
												$( '<div/>' )
													.addClass( 'name capitalize' )
													.html( item.name )
											);
										var conferenceDetail =
										$( '<div/>' )
											.addClass( 'detail' )
											.append(
												$( '<span/>' )
													.addClass( 'name capitalize' )
													.html( " " + item.year )
											);
										conferenceDiv
											.append(
												conferenceNav
											).append(
												conferenceDetail
											).append('&nbsp;')
											.on('click', function(d){ 
												
													
													if(type=="conference"){
														obj = {
																type:"listItem",
														        clientX:d.clientX,
														        clientY:d.clientY,
														        itemId:item.id,
														        objectType:"conference"
														};
														showhoverdiv(obj,'divtoshow', "This conference type is already added");
													}
													else
													{
														obj = {
																  type:"listItem",
														          clientX:d.clientX,
														          clientY:d.clientY,
														          itemId:item.id,
														          objectType:"conference"
														};
														if(item.isAdded)
															showmenudiv(obj, 'menu')
														else
															showhoverdiv(obj, 'divtoshow', item.name.toUpperCase() + " is currently not present in PALM")
													}
											});
											
										if( !item.isAdded ){
											conferenceDiv.addClass( "text-gray" );
										}
											
										listSection
											.append( 
												conferenceDiv
											);
									});			
							}
							
							if(visType == "topics")
							{
									var sortedList = data.map.list.sort();
									<#-- build the conference list -->
									$.each( sortedList , function( index, item){
									
										var topicDiv = 
										$( '<div/>' )
											.addClass( 'author' )
											.attr({ 'id' : item[0] });
										var topicNav =
										$( '<div/>' )
											.addClass( 'nav' )
											.append(
												$( '<div/>' )
													.addClass( 'name capitalize' )
													.html( item[0] )
											);
										topicDiv
											.append(
												topicNav
											).append('&nbsp;')
											.on('click', function(d){ 
												obj = {
															  type:"listItem",
													          clientX:d.clientX,
													          clientY:d.clientY,
													          itemId:item.id,
													          objectType:"topic"
													};
												showmenudiv(obj, 'menu')
											});
											
										listSection
											.append( 
												topicDiv
											);
									});			
							}
							
							if(visType == "publications")
							{
									<#-- build the conference list -->
									$.each( data.map.pubDetailsList, function( index, item){
									
										var conferenceDiv = 
										$( '<div/>' )
											.addClass( 'author' )
											.attr({ 'id' : item.id });
										var conferenceNav =
										$( '<div/>' )
											.addClass( 'nav' )
											.append(
												$( '<div/>' )
													.addClass( 'name capitalize' )
													.html( item.title )
											);
										var conferenceDetail =
										$( '<div/>' )
											.addClass( 'detail' )
											.append(
												$( '<span/>' )
													.addClass( 'name capitalize' )
													.html( " " + item.year )
											);
										conferenceDiv
											.append(
												conferenceNav
											).append(
												conferenceDetail
											).append('&nbsp;')
											.on('click', function(d){ 
												obj = {
															  type:"listItem",
													          clientX:d.clientX,
													          clientY:d.clientY,
													          itemId:item.id,
													          objectType:"publication"
													};
												showmenudiv(obj, 'menu')
											
											});
											
										listSection
											.append( 
												conferenceDiv
											);
									});			
							}
							
						});
		}
		
		<#-- COMPARISON TAB -->
		function tabVisComparison(uniqueVisWidget, url, widgetElem, tabContent){
			
		$.getJSON( url , function( data ) {
			
			<#-- remove  pop up progress log -->
			$.PALM.popUpMessage.remove( uniqueVisWidget );
			
			console.log("comaprison data");
			console.log(data);
			
			var tabComparisonContainer = $( widgetElem ).find( "#tab_Comparison" );
			tabComparisonContainer.html("");
			
			var extraContainer = $( '<div/>' ).css("height","67vh")
			tabComparisonContainer.append(extraContainer)

			var vennContainer = $( '<div/>' ).attr("id","vennContainer").css("height","67vh").css("width","70%").css("float","left");
			var listContainer = $( '<div/>' ).attr("id","listContainer").css("height","67vh").css("width","30%").css("float","right");
			
			extraContainer.append(vennContainer);
			extraContainer.append(listContainer);
			
			
			var innerListContainer = $( '<div/>' ).attr("id","innerListContainer").css('overflow-y','scroll')
								.css('max-height','67vh')
			listContainer.append(innerListContainer);
			
							
							$("#innerListContainer").slimscroll({
								height: "67vh",
						        size: "5px",
					        	allowPageScroll: true,
					   			touchScrollStep: 50,
					   			//alwaysVisible: true
					       });
			
			
			var vennD = $( '<div/>' ).attr("id","venn").css("height","67vh");
			vennContainer.append(vennD);
			var vennListC = $( '<div/>' );
			innerListContainer.append(vennListC);
			var clickFlag = "false";
			var selectedVenn = "";
			var chart = venn.VennDiagram()
			dataComp = data.map.comparisonList
			
			<#-- data list are also here // use later-->
			
			var div = d3.select("#venn")
			div.datum(dataComp).call(chart);
			
			div.on("click", function(d,i){
					hidehoverdiv('divtoshow')
					hidemenudiv('menu')
					vennListC.html("");
					var s  = d3.selectAll("path")
					s.style("stroke-width", 0)
			            .style("fill-opacity", d.sets.length == 1 ? .25 : .0)
			            .style("stroke-opacity", 0);
				})
			
			var tooltip = d3.select("body").append("div")
			    .attr("class", "venntooltip");
			
			div.selectAll("path")
			    .style("stroke-opacity", 0)
			    .style("stroke", "#fff")
			    .style("stroke-width", 0)
			
			div.selectAll("g")
			    .on("mouseover", function(d, i) {
			        // sort all the areas relative to the current item
			        venn.sortAreas(div, d);
			
			        // Display a tooltip with the current size
			        tooltip.transition().duration(400).style("opacity", .9);
			        tooltip.text(d.size);
			        // highlight the current path
			        var selection = d3.select(this).transition("tooltip").duration(400);
			        selection.select("path")
			        	.style("stroke","black")
			            .style("stroke-width", 3)
			            .style("fill-opacity", d.sets.length == 1 ? .4 : .1)
			            .style("stroke-opacity", 1);
			    })
			
			    .on("mousemove", function(d,i) {
			        tooltip.style("left", (d3.event.pageX) + "px")
			               .style("top", (d3.event.pageY - 28) + "px");
			    })
			
			    .on("mouseout", function(d, i) {
			        tooltip.transition().duration(400).style("opacity", 0);
			        
			        if(selectedVenn!=d.altLabel){
			        var selection = d3.select(this).transition("tooltip").duration(400);
			        selection.select("path")
			            .style("stroke-width", 0)
			            .style("fill-opacity", d.sets.length == 1 ? .25 : .0)
			            .style("stroke-opacity", 0);
			        }    
			    })
				
				.on("click", function(d,i){
				
					selectedVenn = d.altLabel;
					vennListC.html("");
					vennList(vennListC, d.list, d.idsList)
					
					var s  = d3.selectAll("path").filter(function(x) { 
					return d.altLabel!=x.altLabel; });
					s.style("stroke-width", 0)
			            .style("stroke-opacity", 0);
			        d3.event.stopPropagation();    
				})
					
			});
		}
		
		function vennList(vennListC, nameList, idsList){
									<#-- build the researcher list -->
									$.each( nameList, function( index, item){
										var vennDiv = 
										$( '<div/>' )
											.addClass( 'author' )
											.attr({ 'id' : item[1].id });
										var vennNav =
										$( '<div/>' )
											.addClass( 'nav' );
										var vennDetail =
										$( '<div/>' )
											.addClass( 'detail' )
											.append(
												$( '<div/>' )
													.addClass( 'name capitalize' )
													.html( (index+1)+") "+item[0].name )
											);
										vennDiv
											.append(
												vennNav
											).append(
												vennDetail
											)
											.on('click', function(d){ 
												console.log(d);
												
												obj = {
														  type:"comparisonListItem",
												          clientX:d.clientX,
												          clientY:d.clientY,
												          itemId:item[1].id,
												          objectType:visType.substring(0,visType.length-1)
												};
												if(visType == "researchers" || visType == "conferences"){
													if(item[2].isAdded)
														showmenudiv(obj, 'menu')
													else
														showhoverdiv(obj, 'divtoshow', item[0].name.toUpperCase() + " is currently not present in PALM")
												}		
												else
														showmenudiv(obj, 'menu')
											});
										if(visType == "researchers" || visType == "conferences"){	
											if( !item[2].isAdded ){
												vennDiv.addClass( "text-gray" );
											}
										}
										vennListC
											.append( 
												vennDiv
											);
									});
		}
		<#-- SIMILARITY TAB -->
		function tabVisSimilar(uniqueVisWidget, url, widgetElem, tabContent){
			$.getJSON( url , function( data ) {
				
				console.log("similar data")
				console.log(data)
			
				<#-- remove  pop up progress log -->
				$.PALM.popUpMessage.remove( uniqueVisWidget );
				
				var similarTab = $( widgetElem ).find( "#tab_Similar" );
				similarTab.html("");
				
				var similarDiv = $('<div/>')
							.addClass("similarity")
							.css('overflow-y','scroll')
							
				similarTab.append(similarDiv);
				
				$(".similarity").slimscroll({
							height: "67vh",
					        size: "5px",
				        	allowPageScroll: true,
				   			touchScrollStep: 50,
				   			//alwaysVisible: true
				});		
				
				var innerDiv = $('<div/>').attr('id','sim_tab')
				
				similarDiv.append(innerDiv)	
				
				<#-- http://bl.ocks.org/kiranml1/6872226 -->
				var grid = d3.range(15).map(function(i){
					return {'x1':0,'y1':0,'x2':0,'y2':480};
				});
		
				var tickVals = grid.map(function(d,i){
					if(i>0){ return i*10; }
					else if(i===0){ return "100";}
				});
		
				var xscale = d3.scale.linear()
								.domain([0,209])
								.range([0,822]);
		
				var yscale = d3.scale.linear()
								.domain([0,data.map.authorNames.length])
								.range([0,580]);
		
				var colorScale = d3.scale.linear()
								.domain([0,data.map.authorNames.length])
								.range(["green","#c4e6fc"]);
		
				var canvas = d3.select('#sim_tab')
								.append('svg')
								.attr({'width':700,'height':700})
				
				canvas.on("click", function(e) { hidemenudiv('menu'); })		
			
				var chart = canvas.append('g')
								//.attr("transform", "translate(150,0)")
								.attr('id','bars')
								.selectAll('rect')
								.data(data.map.similarity)
								.enter()
								.append('rect')
								.attr('height',15)
								.attr({'x':0,'y':function(d,i){ return yscale(i)+19; }})
								.style('fill',function(d,i){ return colorScale(i); })
								.attr('width',function(d){ return 0; })
								.on("click", function(e, i){
									
									obj = {
											  type:"similarBar",
									          clientX:d3.event.clientX,
									          clientY:d3.event.clientY,
									          authorId:data.map.authorIds[i]
									};
									
									showmenudiv(obj,'menu');
									d3.event.stopPropagation();
								})
								.on("mouseover", function(d,i){
									obj = {
												  type:"similarBar",
										          clientX:d3.event.clientX,
										          clientY:d3.event.clientY,
										          authorId:data.map.authorIds[i]
									};
									
									var intarr = [] 
									intarr = Object.keys(data.map.interests[i])
									var count = 5;
									if(intarr.length<5)
										count = intarr.length
										
								var str = "Top common interests:";
								for(var i=0; i<count; i++)
									str = str +  "<br /> - " + intarr[i] 
										
									showhoverdiv(obj,'divtoshow', str);
								})
								.on("mouseout", function(e,i){
									hidehoverdiv('divtoshow');
								})
	
	
			var transit = d3.select("svg").selectAll("rect")
							    .data(data.map.similarity)
							    .transition()
							    .duration(1000) 
							    .attr("width", function(d) {return xscale(d); });
	
			var transitext = d3.select('#bars')
							.selectAll('text')
							.data(data.map.authorNames)
							.enter()
							.append('text')
							.attr({'x':function(d) {return 0; },'y':function(d,i){ return yscale(i)+15; }})
							.text(function(d){ return d; }).style({'fill':'black','font-size':'11px'})
							.on("mouseover", function(d,i){
									obj = {
												  type:"similarBar",
										          clientX:d3.event.clientX,
										          clientY:d3.event.clientY,
										          authorId:data.map.authorIds[i]
									};
									
									var intarr = [] 
									intarr = Object.keys(data.map.interests[i])
									var count = 5;
									if(intarr.length<5)
										count = intarr.length
										
								var str = "Top common interests:";
								for(var i=0; i<count; i++)
									str = str +  "<br /> - " + intarr[i] 
								
									showhoverdiv(obj,'divtoshow', str);
								})
								.on("mouseout", function(e,i){
									hidehoverdiv('divtoshow');
								})
			});
		}
		
		function visualizeCluster(data, tabContainer , visType){
			var margin = {top: -300, right: -100, bottom: 200, left: -5};
			
			var color = d3.scale.ordinal()
    						.range(customColors); 
			var width = tabContainer.width();
			var height = tabContainer.width();  //	screen.height * 0.68; 
				
			var zoom = d3.behavior.zoom()
						.scaleExtent([0, 10])
						.on("zoom", zoomed);
						
			clusters = new Array(getClusters(data)); 
			
			nodes = data.map(function(d) {
				  if(visType == "researchers" || visType=="publications"){
			      	new_data = {cluster: d.cluster, radius: 20, id: d.id, name: d.name, clusterTerms : d.clusterTerms};
				  }
				  if(visType == "conferences"){
			      	new_data = {cluster: d.cluster, radius: 20, id: d.id, name: d.name, abr: d.abr, clusterTerms : d.clusterTerms};
				  }
				  if (!clusters[d.cluster]) {clusters[d.cluster] = new_data;}
				  return new_data;
				});
			d3.layout.pack()
			    .sort(null)
			    .size([width, height])
			    .children(function(d) { return d.values; })
			    .value(function(d) { return d.radius * d.radius; })
			    .nodes({values: d3.nest()
			      .key(function(d) { return d.cluster; })
			      .entries(nodes)});	
				
			force = d3.layout.force()
							.nodes(nodes)
						    .size([width, height])
						    .gravity(0.02) 
						    .charge(0)
						    .on("tick", tick)
						    .start();

			vis_researcher = d3.select(".clusters").append("svg")
							    .attr("width", width)
							    .attr("height", height)
							      .append("g")
							    .call(zoom).append("g")
							    .on("click",function(){
									hidemenudiv('menu');			
							    }); 
		    
			var rect2 = vis_researcher.append("rect")
							    .attr("width", width)
							    .attr("height", height)
							    .style("fill", "none")
							    .style("pointer-events", "all"); 
			
			node = vis_researcher.selectAll(".node")
					      .data(nodes)
					      .enter()
					     .append("g")
			      .attr("class", "node")
			      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; })
					.on("click", function(d){
			         console.log(d);
			         obj = {
							type:"clusterItem",
							clientX:d3.event.clientX,
							clientY:d3.event.clientY,
							clusterItem: d.id,
							visType : visType 
						};
			         showmenudiv(obj,'menu');
			         d3.event.stopPropagation();
			      })
			      .on("mouseover",function(d) { 
			      		obj = {
							type:"clusterItem",
							clientX:d3.event.clientX,
							clientY:d3.event.clientY,
							clusterItem: d.id,
							visType : visType 
						};
						
						var str = "";
						for(var i=0; i<d.clusterTerms.length; i++)
							str = str +  "<br /> - " + d.clusterTerms[i] 
						
			      		showhoverdiv(obj, 'divtoshow', d.name + "<br />" + str); 
			      }) 
			      .on("mouseout", function(e,i){
									hidehoverdiv('divtoshow');
								})
			
			 <#-- node.append("title")
			      .text(function(d) { return d.name + "\n" + d.clusterTerms; }); -->
			
			  node.append("circle")
			      .attr("r", function(d) { return d.r; })
			      .style("fill", function(d) { return color(d.cluster); })
			//if(visType!="publications")
			//{
			  node.append("svg:text")
			      .attr("dy", ".3em")
			      .style("text-anchor", "middle")
			      .text(function(d) { 
			      	if(visType=="researchers" || visType=="publications")
			      		return d.name;
			      	if(visType=="conferences")
			      		return d.abr;
			      })
			      .style("font-size", function(d) { 
			      	if(this.getComputedTextLength()!=0)
			      	{
				      return Math.min(2 * d.r, (2 * d.r - 1) / this.getComputedTextLength() * 10) + "px";
				    }
				    else
				    	return Math.min(2 * d.r, (2 * d.r - 1) / 120 * 10) + "px"; 
			      })
			//}
			
			node.transition()
			    .duration(750)
			    .delay(function(d, i) { return i * 5; })
			    .attrTween("r", function(d) {
			      var i = d3.interpolate(0, d.radius);
			      return function(t) { return d.radius = i(t); };
			    });
			 
			 groups = d3.nest().key(function(d) { return d.cluster }).entries(nodes);

			groupPath = function(d) {
			   var fakePoints = [];
			    if (d.values.length == 2)
			    {
			        //[dx, dy] is the direction vector of the line
			        var dx = d.values[1].x - d.values[0].x;
			        var dy = d.values[1].y - d.values[0].y;
			
			        //scale it to something very small
			        dx *= 0.00001; dy *= 0.00001;
			
			        //orthogonal directions to a 2D vector [dx, dy] are [dy, -dx] and [-dy, dx]
			        //take the midpoint [mx, my] of the line and translate it in both directions
			        var mx = (d.values[0].x + d.values[1].x) * 0.5;
			        var my = (d.values[0].y + d.values[1].y) * 0.5;
			        fakePoints = [ [mx + dy, my - dx],
			                      [mx - dy, my + dx]];
			        //the two additional points will be sufficient for the convex hull algorithm
			    }
			       
			   return "M" + d3.geom.hull(d.values.map(function(d) { return [d.x, d.y]; })
			       .concat(fakePoints))  //do not forget to append the fakePoints to the group data
			       .join("L") + "Z";
			};
			    
			groupFill = function(d,i) { return color(d.values[0].cluster); };
			    
			 vis_researcher.selectAll("path")
			    .data(groups)
			      .attr("d", groupPath)
			    .enter().insert("path", "g")
			      .style("fill", groupFill)
			      .style("stroke", groupFill)
			      .style("stroke-width", 100)
			      .style("stroke-linejoin", "round")
			      .style("opacity", .3)
			      .attr("d", groupPath)
			      .on("click", function(d){
			         var list = [];
			         for(var i=0; i< d.values.length; i++){
			         	list.push(d.values[i].id)
			         }
			         obj = {
							type:"cluster",
							clientX:d3.event.clientX,
							clientY:d3.event.clientY,
							clusterItems: list,
							visType : visType 
						};
			         showmenudiv(obj,'menu');
			         d3.event.stopPropagation();
			      })
			     .on("mouseover",function(d) {
			     var list = [];
			         for(var i=0; i< d.values.length; i++){
			         	list.push(d.values[i].id)
			         }
			     	obj = {
							type:"cluster",
							clientX:d3.event.clientX,
							clientY:d3.event.clientY,
							clusterItems: list,
							visType : visType 
						}; 
						
				   var str = "Cluster topics/interests:";
						for(var i=0; i<d.values[0].clusterTerms.length; i++)
							str = str +  "<br /> - " + d.values[0].clusterTerms[i] 
									
			      showhoverdiv(obj, 'divtoshow', str); 
			     }) 
			     .on("mouseout", function(e,i){
									hidehoverdiv('divtoshow');
								})
				<#--.append("title")
			      .text(function(d) { 
			      return d.values[0].clusterTerms; });    -->
		}
		
		function getClusters(data){
		var groups = [];
		
		      for(var i=0; i<data.length; i++){
		          if(groups.indexOf(data[i].cluster) == -1){
		                  groups.push(data[i].cluster);
		          }
		      }
		  return groups.length;
		}
		
		function tick(e) {
		  node
		     .each(cluster(10 * e.alpha * e.alpha))
		      .each(collide(.5))
		      .attr("cx", function(d) { return d.x; })
		      .attr("cy", function(d) { return d.y; });
			}
			
			// Move d to be adjacent to the cluster node.
			function cluster(alpha) {
			  return function(d) {
			    var cluster = clusters[d.cluster];
			    if (cluster === d) return;
			    var x = d.x - cluster.x,
			        y = d.y - cluster.y,
			        l = Math.sqrt(x * x + y * y),
			        r = d.radius + cluster.radius;
			    if (l != r) {
			      l = (l - r) / l * alpha;
			      d.x -= x *= l;
			      d.y -= y *= l;
			      cluster.x += x;
			      cluster.y += y;
			    }
			  };
			}
			
			// Resolves collisions between d and all other circles.
			function collide(alpha) {
			  var quadtree = d3.geom.quadtree(nodes);
			 
			 	var padding = 5.5; <#-- separation between same-color nodes -->
	    		var clusterPadding = 10; <#-- separation between different-color nodes -->
	    		var maxRadius = 100;
			 
			  return function(d) {
			    var r = d.radius + maxRadius + Math.max(padding, clusterPadding),
			        nx1 = d.x - r,
			        nx2 = d.x + r,
			        ny1 = d.y - r,
			        ny2 = d.y + r;
			    quadtree.visit(function(quad, x1, y1, x2, y2) {
			      if (quad.point && (quad.point !== d)) {
			        var x = d.x - quad.point.x,
			            y = d.y - quad.point.y,
			            l = Math.sqrt(x * x + y * y),
			            r = d.radius + quad.point.radius + (d.cluster === quad.point.cluster ? padding : clusterPadding);
			        if (l < r) {
			          l = (l - r) / l * alpha;
			          d.x -= x *= l;
			          d.y -= y *= l;
			          quad.point.x += x;
			          quad.point.y += y;
			        }
			      }
			      return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
			    });
			  };
			}
		
		function zoomed() {
		  vis_researcher.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
		}
		
		function visBubbles(data){
		
		var color = d3.scale.ordinal().range(customColors),
		    diameter = 500;
		    
		var zoom = d3.behavior.zoom()
						.scaleExtent([0, 10])
						.on("zoom", zoomedBubbles);    
		    
		var bubble = d3.layout.pack()
		      .value(function(d) { return d3.sum(d[1]); })
		      .sort(function(a, b) {
				    return -(a.value - b.value);
				})
		      .size([diameter, diameter])
		      .padding(1.5),
		    arc = d3.svg.arc().innerRadius(0),
		    pie = d3.layout.pie();
		
		svg = d3.select("#tab_Bubbles").append("svg")
		    .attr("width", diameter)
		    .attr("height", diameter)
		    .attr("class", "bubble")
		      .append("g")
		    .call(zoom).append("g");
		    
	   var rect2 = svg.append("rect")
						    .attr("width", diameter)
						    .attr("height", diameter)
						    .style("fill", "none")
						    .style("pointer-events", "all"); 
		
		var container = svg.append("g");

		container.append("g")
		
		var nodes = container.selectAll("g.node")
		    .data(bubble.nodes({children: data}).filter(function(d) { return !d.children; }));
		nodes.enter().append("g")
		    .attr("class", "node")
		    .attr("transform", function(d) { return "translate(" + (d.x + 50) + "," + (d.y - 40) + ")"; })
			.on("click", function(d){
			        	console.log(d);} );		  
		
		arcGs = nodes.selectAll("g.arc")
		    .data(function(d) {
		      return pie(d[1]).map(function(m) { m.r = d.r; return m; });
		    })
		    
		var arcEnter = arcGs.enter().append("g").attr("class", "arc");
		
		arcEnter.append("path")
		    .attr("d", function(d) {
		      arc.outerRadius(d.r);
		      return arc(d);
		    })
		    .style("fill", function(d, i) { return color(i); });
		
		
		nodes.append("text")
	      .attr("dy", ".3em")
	      .style("text-anchor", "middle")
	      .text(function(d) { return [d[0]]; })
	      .style("font-size", function(d) { return Math.min(2 * d.r, (2 * d.r - 1) / this.getComputedTextLength() * 10) + "px"; })
			
		
		}
		
		function zoomedBubbles() {
		  svg.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
		}
		
		function drawDimpleChart(data){
			
			var numberOfTopics = dimple.getUniqueValues(data, "Topic");
			if(numberOfTopics.length * 40 > 400)
				height = numberOfTopics.length * 40
			else
				height = 400
					
			var svg = dimple.newSvg("#chartTab", "100%", height);
			var chart = new dimple.chart(svg, data);
			var y = chart.addCategoryAxis("y", ["Topic", "Author"]);
			y.addOrderRule("Topic", true);
			chart.addCategoryAxis("x", "Year");
			//chart.addMeasureAxis("z", "Weight");
			var s = chart.addSeries("Author", dimple.plot.bubble);
			
			var myLegend = chart.addLegend(0, 10, 500, 400, "right");
			chart.draw();
			y.shapes.selectAll("text")
			  .call(wrap, 30);
			
			$('#chartTab').contents().appendTo("#svgContainer");
			
			chart.legends = [];
			// Get a unique list of Owner values to use when filtering
			var filterValues = dimple.getUniqueValues(data, "Author");
			// Get all the rectangles from our now orphaned legend
			myLegend.shapes.selectAll("rect")
			  // Add a click event to each rectangle
			  .on("click", function(e) {
			    // This indicates whether the item is already visible or not
			    var hide = false;
			    var newFilters = [];
			    // If the filters contain the clicked shape hide it
			    filterValues.forEach(function(f) {
			      if (f === e.aggField.slice(-1)[0]) {
			        hide = true;
			      } else {
			        newFilters.push(f);
			      }
			    });
			    // Hide the shape or show it
			    if (hide) {
			      d3.select(this).style("opacity", 0.2);
			    } else {
			      newFilters.push(e.aggField.slice(-1)[0]);
			      d3.select(this).style("opacity", 0.8);
			    }
			    // Update the filters
			    filterValues = newFilters;
			    // Filter the data
			    chart.data = dimple.filterData(data, "Author", filterValues);
			    // Passing a duration parameter makes the chart animate. Without
			    // it there is no transition
			    chart.draw();
			    y.shapes.selectAll("text")
			      .call(wrap, 50);
			  });
			
			svg.selectAll("circle")
				.on("click",function(e){
			  })
		}
		
		function wrap(text, width) {
		  text.each(function() {
		    var text = d3.select(this),
		      words = text.text().split(/\s+/).reverse(),
		      word,
		      line = [],
		      lineNumber = 0,
		      lineHeight = 0.8, // ems
		      y = text.attr("y"),
		      dy = parseFloat(text.attr("dy")),
		      tspan = text.text(null).append("tspan").attr("x", -3).attr("y", y).attr("dy", -dy + "em");
		    while (word = words.pop()) {
		      line.push(word);
		      tspan.text(line.join(" "));
		      if (tspan.node().getComputedTextLength() > width) {
		        line.pop();
		        tspan.text(line.join(" "));
		        line = [word];
		        tspan = text.append("tspan").attr("x", -3).attr("y", y).attr("dy", ++lineNumber * lineHeight - dy + "em").text(word);
		      }
		    }
		  });
		}		
		
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wUniqueName}",
			"element": $( "#widget-${wUniqueName}" ),
			"options": options
		});
		
		<#--// first time on load, list 50 researchers-->
		$.PALM.boxWidget.refresh( $( "#widget-${wUniqueName}" ) , options );
		
	});
	
	<#-- javascript -->
		function showhoverdiv(e,divid, text){
			hidemenudiv('menu')
			document.getElementById(divid).innerHTML = text;
		    var left;
			var top;
			
			if(e.type == "similarBar" || e.type == "cluster" || e.type == "clusterItem"){
			    left  = (e.clientX - 10) + "px";
			    top  = (e.clientY  + 20) + "px";
		    }
		    
		    if(e.type == "clickNode" || e.type == "overEdge"){
			    left  = (e.data.captor.clientX) + "px";
			    top  = (e.data.captor.clientY) + "px";
		    }
		    
		     if(e.type == "clickLocation"){
			    left  = (e.clientX + 350) + "px";
			    top  = (e.clientY + 250) + "px";
		    }
		    
		    if(e.type == "comparisonListItem"){
			    left  = (e.clientX) + "px";
			    top  = (e.clientY) + "px";
		    }
		    
		    if(e.type == "listItem"){
			    left  = (e.clientX) + "px";
			    top  = (e.clientY) + "px";
		    }
		    
		    var div = document.getElementById(divid);
		
		    div.style.left = left;
		    div.style.top = top;
			div.style.display = "inline"
		    return false;
		}
		function hidehoverdiv(divid){
		    var div = document.getElementById(divid);
			div.style.display = "none"
		    return false;
		}
		function showmenudiv(e,divid){
			hidehoverdiv('divtoshow')
			console.log("names in here:  " + names)
			console.log("vis TYPE: " + visType.substring(0,visType.length-1));
			console.log("object TYPE: " + objectType);
			console.log(e)
			
			var left;
			var top;
			
			if(e.type == "similarBar" || e.type=="clickPublication" || e.type == "cluster" || e.type == "clusterItem"){
			    left  = (e.clientX - 330) + "px";
			    top  = (e.clientY - 140) + "px";
		    }
		    
		    if(e.type == "clickLocation"){
			    left  = (e.clientX) + "px";
			    top  = (e.clientY) + "px";
		    }
		    
		    if(e.type == "comparisonListItem"){
			    left  = (e.clientX - 330) + "px";
			    top  = (e.clientY - 140) + "px";
		    }

		    if(e.type == "clickNode" || e.type == "clickEdge"){
			    left  = (e.data.captor.clientX - 350) + "px";
			    top  = (e.data.captor.clientY  - 150) + "px";
		    }
		    
		    if(e.type == "listItem"){
			    left  = (e.clientX - 330) + "px";
			    top  = (e.clientY - 140) + "px";
		    }
		    console.log("divid: " + divid)
		    var div = document.getElementById(divid);
		    div.style.left = left;
		    div.style.top = top;
			div.style.display = "block";
			
			if(e.type == "clickNode"){
				$("#coauthors").show();
				<#-- do not show menu if the object is there in the setup already -->
				if(names.indexOf(e.data.node.label) != -1){
					$(".menu").hide();
				}
				else
				{
					$(".menu").show();
					
					<#-- append is invalid if the types are different -->
					if(visType.substring(0,visType.length-1)!=objectType)
					{
						$("#append").hide();
					}
					else
						$("#append").show();
				}	
			}
			
			if(e.type == "clickEdge" || e.type == "similarBar" || e.type == "clickLocation" || e.type == "clickPublication" || e.type == "comparisonListItem" || e.type == "listItem" || e.type == "cluster" || e.type == "clusterItem"){
					$(".menu").show();
	
				<#-- do not show menu if the object is there in the setup already -->
					$("#coauthors").hide();
			}
			
			<#-- append is invalid if the types are different -->
					if(visType.substring(0,visType.length-1)!=objectType)
					{
						$("#append").hide();
					}
					else
						$("#append").show();
				
			<#-- set the value of clicked node in the menu -->
			div.value = e;
		    return false;
		}
		function hidemenudiv(divid){
			var div = document.getElementById(divid);
			div.style.display = "none"
		    return false;
		}
		
		<#-- JQUERY -->

	$('#append').click(function(e){
		var targetVal = [];
		
		if($(this).parent().parent()[0].value.type=="clickNode"){
			targetVal.push($(this).parent().parent()[0].value.data.node.attributes.authorid);
			itemAdd(targetVal,"researcher");
		}	
		
		if($(this).parent().parent()[0].value.type=="clickEdge")
		{
			if($(this).parent().parent()[0].value.data.edge.attributes.sourceauthorisadded)
			targetVal.push($(this).parent().parent()[0].value.data.edge.attributes.sourceauthorid);
			
			if($(this).parent().parent()[0].value.data.edge.attributes.targetauthorisadded)
			targetVal.push($(this).parent().parent()[0].value.data.edge.attributes.targetauthorid);
			
			if(targetVal.length > 0)
				itemAdd(targetVal,"researcher");
		}
		
		if($(this).parent().parent()[0].value.type=="clickPublication"){
			targetVal.push($(this).parent().parent()[0].value.pubId);
			itemAdd(targetVal,"publication");
		}		
		
		if($(this).parent().parent()[0].value.type=="similarBar")
		{
			targetVal.push($(this).parent().parent()[0].value.authorId);
			console.log("visType.substring(0,visType.length-1)" + visType.substring(0,visType.length-1))
			itemAdd(targetVal,visType.substring(0,visType.length-1));
		}

		if($(this).parent().parent()[0].value.type=="clickLocation")
		{
			targetVal.push($(this).parent().parent()[0].value.eventGroupId);
			itemAdd(targetVal,"conference");
		}	
		
		if($(this).parent().parent()[0].value.type=="comparisonListItem")
		{
			targetVal.push($(this).parent().parent()[0].value.itemId);
			itemAdd(targetVal,$(this).parent().parent()[0].value.objectType);
		}
		
		if($(this).parent().parent()[0].value.type=="listItem")
		{
			targetVal.push($(this).parent().parent()[0].value.itemId);
			itemAdd(targetVal,$(this).parent().parent()[0].value.objectType);
		}
		
		if($(this).parent().parent()[0].value.type=="cluster"){

			for(var i=0;i<$(this).parent().parent()[0].value.clusterItems.length; i++)
			{
				targetVal.push($(this).parent().parent()[0].value.clusterItems[i]);
			}
			itemAdd(targetVal,$(this).parent().parent()[0].value.visType.substring(0,visType.length-1));
		}
		
		if($(this).parent().parent()[0].value.type=="clusterItem"){

			targetVal.push($(this).parent().parent()[0].value.clusterItem);
			itemAdd(targetVal,$(this).parent().parent()[0].value.visType.substring(0,visType.length-1));
		}
		
		 hidemenudiv('menu');
		 
		 return false;
	});
	
	$('#replace').click(function(e){
		var targetVal = [];
		if($(this).parent().parent()[0].value.type=="clickNode"){
			targetVal.push($(this).parent().parent()[0].value.data.node.attributes.authorid);
			itemReplace(targetVal,"researcher");
		}	
		
		if($(this).parent().parent()[0].value.type=="clickEdge")
		{
			if($(this).parent().parent()[0].value.data.edge.attributes.sourceauthorisadded)
			targetVal.push($(this).parent().parent()[0].value.data.edge.attributes.sourceauthorid);
			
			if($(this).parent().parent()[0].value.data.edge.attributes.targetauthorisadded)
			targetVal.push($(this).parent().parent()[0].value.data.edge.attributes.targetauthorid);
			
			if(targetVal.length > 0)
				itemReplace(targetVal,"researcher");
		}
		
		if($(this).parent().parent()[0].value.type=="clickPublication"){
			targetVal.push($(this).parent().parent()[0].value.pubId);
			itemReplace(targetVal,"publication");
		}		
		
		if($(this).parent().parent()[0].value.type=="similarBar")
		{
			targetVal.push($(this).parent().parent()[0].value.authorId);
			itemReplace(targetVal,visType.substring(0,visType.length-1));
		}
		
		if($(this).parent().parent()[0].value.type=="clickLocation")
		{
			targetVal.push($(this).parent().parent()[0].value.eventGroupId);
			itemReplace(targetVal,"conference");
		}
		
		if($(this).parent().parent()[0].value.type=="comparisonListItem")
		{
			targetVal.push($(this).parent().parent()[0].value.itemId);
			itemReplace(targetVal,$(this).parent().parent()[0].value.objectType);
		}
		
		if($(this).parent().parent()[0].value.type=="listItem")
		{
			targetVal.push($(this).parent().parent()[0].value.itemId);
			itemReplace(targetVal,$(this).parent().parent()[0].value.objectType);
		}
		
		if($(this).parent().parent()[0].value.type=="cluster"){

			for(var i=0;i<$(this).parent().parent()[0].value.clusterItems.length; i++)
			{
				targetVal.push($(this).parent().parent()[0].value.clusterItems[i]);
			}
			itemReplace(targetVal,$(this).parent().parent()[0].value.visType.substring(0,visType.length-1));
		}
		
		if($(this).parent().parent()[0].value.type=="clusterItem"){

			targetVal.push($(this).parent().parent()[0].value.clusterItem);
			itemReplace(targetVal,$(this).parent().parent()[0].value.visType.substring(0,visType.length-1));
		}
		
		hidemenudiv('menu');
		console.log("targetVAL in replace: " + targetVal)
		return false;
	});
	
	$('#coauthors').click(function(e){
	var targetVal = $(this).parent().parent()[0].value.data.node.attributes.authorid;
	 hidemenudiv('menu');
	 itemCoAuthors(targetVal,"researcher");
	 return false;
	});
	
	function itemAdd(id, type){
		var queryString = "?id="+id+"&type="+type;
		
		<#-- update setup widget -->
		var stageWidget = $.PALM.boxWidget.getByUniqueName( 'explore_setup' ); 
		stageWidget.options.queryString = queryString;
		$.PALM.boxWidget.refresh( stageWidget.element , stageWidget.options );
	}
	
	function itemReplace(id, type){
		var replace = true;
		var queryString = "?id="+id+"&type="+type+"&replace="+replace;
		
		<#-- update setup widget -->
		var stageWidget = $.PALM.boxWidget.getByUniqueName( 'explore_setup' ); 
		stageWidget.options.queryString = queryString;
		$.PALM.boxWidget.refresh( stageWidget.element , stageWidget.options );
	}
	
	function itemCoAuthors(id, type){
		dataTransfer = "true";
		authoridForCoAuthors = id;
		var updateString = "?type="+type+"&dataList="+names+"&idList="+ids+"&visType="+visType+"&dataTransfer="+dataTransfer+"&authoridForCoAuthors="+authoridForCoAuthors;
					
			<#-- update visualize widget -->
			var visualizeWidget = $.PALM.boxWidget.getByUniqueName( 'explore_visualize' ); 
			visualizeWidget.options.queryString = updateString;
			$.PALM.boxWidget.refresh( visualizeWidget.element , visualizeWidget.options );
	}	
	
</script>