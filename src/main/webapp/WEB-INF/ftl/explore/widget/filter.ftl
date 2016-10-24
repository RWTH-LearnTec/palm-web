<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:77vh;overflow:hidden">
  	<div class="filter_widget" class="nav-tabs-custom">
  		<div id="apply_button" style="display:none">
  			<input type="button" value="Apply" id="button" style="margin:auto;display:block;width:10vh;left-margin:40vh,background-color:#d9c7c6;font-size:12px;border:1px solid black;border-radius:0.5em;margin-top:3px;padding-left:5px;padding-right:5px;cursor:pointer;" onclick="checkBoxChange()">
  		</div>
  		<div class="widget_body" style="height:120vh;">
  		</div>
	</div>
</div>

<script>
	$( function(){
		
		objectType = "";
		filterList = [];
		checkedPubValues = [];
		checkedConfValues = [];
		checkedTopValues = [];
		checkedCirValues = [];
		startYear = 0;
		endYear = 0;
		visType = "";
		
		<#-- generate unique id for progress log -->
		var uniquePidTopicWidget = $.PALM.utility.generateUniqueId();
		var options ={
			source : "<@spring.url '/explore/filter' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
					<#-- generate unique id for progress log -->
					uniqueFilterWidget = $.PALM.utility.generateUniqueId();
						},
			onRefreshDone: function(  widgetElem , data ){
			
			<#-- show pop up progress log -->
			$.PALM.popUpMessage.create( "Loading Filters..", { uniqueId:uniqueFilterWidget, popUpHeight:40, directlyRemove:false , polling:false});
			
			$(".widget_body").slimscroll({
				height: "75vh",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50,
	   			//alwaysVisible: true
		  });
			
				names = data.dataList;
				ids = data.idsList;
			
				var targetContainer = $( widgetElem ).find( ".widget_body" );
				
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
				
				<#-- Filters depending on type of visualization-->
				if(objectType=="researcher")
				{
					if(visType=="researchers"){
						filterList = ["Time","Publications", "Conferences", "Topics","Circles"];
					}
					if(visType=="conferences"){
						filterList = ["Time","Topics", "Conferences"];
					}		
					if(visType=="publications"){
						filterList = ["Time","Topics", "Researchers", "Conferences"];
					}
					if(visType=="topics"){
						filterList = ["Time","Publications", "Researchers", "Conferences"];
					}
				}
				
				if(objectType=="conference")
				{
					if(visType=="researchers"){
						filterList = ["Time","Publications", "Topics"];
					}
					if(visType=="conferences"){
						filterList = ["Time","Topics"];
					}		
					if(visType=="publications"){
						filterList = ["Time","Topics"];
					}
					if(visType=="topics"){
						filterList = ["Time","Publications", "Researchers", "Conferences"];
					}
				}
				
				if(objectType=="publication")
				{
					if(visType=="researchers"){
						filterList = ["Time", "Conferences", "Topics","Circles"];
					}
					if(visType=="conferences"){
						filterList = ["Time", "Topics", "Conferences"];
					}		
					if(visType=="publications"){
						filterList = ["Time","Topics", "Researchers", "Conferences"];
					}
					if(visType=="topics"){
						filterList = ["Time", "Researchers", "Conferences"];
					}
				}
				
				
				$.getJSON( "<@spring.url '/explore/filter' />"+"?filterList="+filterList+"&dataList="+names+"&idList="+ids+"&type="+objectType+"&visType="+visType+"&startYear="+startYear+"&endYear="+endYear , function( data ) {
					<#-- remove  pop up progress log -->
					$.PALM.popUpMessage.remove( uniqueFilterWidget );
				
				if(data.type!="undefined" && data.visType!="undefined")
				{
				
				console.log("FILTERS: ....... ")
				console.log(data)
				
					targetContainer.html("");
	    			
	    			if(ids.length!=0)
	    			{
		    			var applyButton = $( widgetElem ).find( "#apply_button" );
		    			applyButton.css("display","block");
		    			
		    			targetContainer
		    				.append(
		    					$('<div/>')
		    						.css("width","20%")
		    						.css("padding-left","6px")
		    						.css("padding-top","20px")
		    						.css("float","left")
		    						.append(
		    							$('<label/>')
		    								.attr("for","year_range")
		    								.html("Year(s):")		
		    						)
		    				)	
							.append(
								$('<div/>')
									.css("padding-left","10px")
									.css("padding-right","10px")
									.css("width","80%")
									.css("float","right")
									.append(
										$('<input/>')
											.attr('type','text')
											.attr('id','year_range')
									)
							)				
						
						startYear = data.TimeFilter.startYear; 
						endYear = data.TimeFilter.endYear;	
							
						$("#year_range").html("");
						$("#year_range").ionRangeSlider({
				            hide_min_max: true,
				            keyboard: true,
				            min: data.TimeFilter.startYear,
				            max: data.TimeFilter.endYear,
				            type: 'double',
				            step: 1,
				            grid: true
			        	});
			        	
			        	var $range = $("#year_range");
			
						$range.on("change", function () {
						    var $this = $(this),
						        value = $this.prop("value").split(";");
						
						    startYear = value[0]; 
						    endYear = value[1];
						});
		    		
		    			var filters = $('<div/>').addClass("other_filters");
		    			targetContainer.append(filters);
					}
								
					var filterContent = $( widgetElem ).find( ".other_filters" );
					filterContent.html("");			
		
					
						<#-- PUBLICATIONS FILTER -->
						if(data.publicationFilter.publicationsList.length!=0){
							var pubSectionHeader = $( '<span/>' ).html("PUBLICATIONS (" + data.publicationFilter.publicationsList.length + ") :")
											.append('&nbsp;')
											.append(
												$('<span/>')
												.append(
													$('<input/>')
													.attr('type','checkbox')
													.attr('value', 'All')
													.on("click", function(){togglePub(this)})
												 )
											);
							var pubSection = $( '<div/>' );
							filterContent.append(pubSectionHeader);
							filterContent.append(pubSection);
							pubSection.addClass('pub_list')
								.css('overflow-y','scroll')
								.css('height', 'auto')
								.css('background-color', 'hsla(120, 100%, 50%, 0.2)')
								.css('max-height', '23vh')
							
							$(".pub_list").slimscroll({
								height: "23vh",
						        size: "10px",
					        	allowPageScroll: true,
					   			touchScrollStep: 50,
					   			color: '#008000'
					       });
					
							<#-- build the Publication Filter list -->
							var sortedPublicationList = data.publicationFilter.publicationsList.sort(function(a, b) 
							{
								return sortList(a.title, b.title);
							})
							$.each( sortedPublicationList, function( index, item){
							var publicationDiv = 
									$( '<div/>' )
										.addClass('authorExplore')
										.attr({ 'id' : item.id })
										.css('padding-left','4px')
										.css('padding-right','4px')
										.append(
											$('<input/>')
												.attr('type','checkbox')
												.attr('name','publicationCB')
												.attr('value', item.title)
												.attr({ 'id' : item.id })
											 )
										.append(
											$( '<span/>' )
												.addClass( 'name' )
												.html( " " +  item.title.toUpperCase() )
										)
										pubSection
											.append( 
												publicationDiv
											);
									});
							}	
							
						<#-- CONFERENCE FILTER -->
						if(data.conferenceFilter.eventsList.length!=0){
						
							var confSectionHeader = $( '<span/>' ).html("CONFERENCES (" + data.conferenceFilter.eventsList.length + ") :")
											.append('&nbsp;')
											.append(
												$('<span/>')
												.append(
													$('<input/>')
													.attr('type','checkbox')
													.attr('value', 'All')
													.on("click", function(){toggleConf(this)})
												 )
											);
							var confSection = $( '<div/>' );
							filterContent.append(confSectionHeader);
							filterContent.append(confSection);
					
							confSection.addClass('conf_list')
								.css('overflow-y','scroll')
								.css('height', 'auto')
								.css('background-color', 'hsla(70,100%,50%,0.2)')
								.css('max-height', '23vh')
							
							$(".conf_list").slimscroll({
								height: "23vh",
						        size: "10px",
					        	allowPageScroll: true,
					   			touchScrollStep: 50,
					   			color: '#008000'
					       });
					
							<#-- build the Conference Filter list -->
							var sortedConferenceList = data.conferenceFilter.eventsList.sort(function(a, b) 
							{
								return sortList(a.title, b.title);
							})
							$.each(sortedConferenceList , function( index, item){
							var conferenceDiv = 
									$( '<div/>' )
										.addClass('authorExplore')
										.attr({ 'id' : item.id })
										.css('padding-left','4px')
										.css('padding-right','4px')
										.append(
											$('<input/>')
												.attr('type','checkbox')
												.attr('name','conferenceCB')
												.attr('value', item.title)
												.attr({ 'id' : item.id })
											 )
										.append(
											$( '<span/>' )
												.addClass( 'name' )
												.html( " " +  item.title.toUpperCase() )
										)
										confSection
											.append( 
												conferenceDiv
											);
									});
							}	
						
						<#-- TOPIC FILTER -->
						if(data.topicFilter.topicDetailsList.length!=0){
						
						 	var topSectionHeader = $( '<span/>' ).html("TOPICS/INTERESTS (" + data.topicFilter.topicDetailsList.length + ") :")
											.append('&nbsp;')
											.append(
												$('<span/>')
												.append(
													$('<input/>')
													.attr('type','checkbox')
													.attr('value', 'All')
													.on("click", function(){toggleTop(this)})
												 )
											);
							var topSection = $( '<div/>' );
								
							filterContent.append(topSectionHeader);
							filterContent.append(topSection);
					
							topSection.addClass('top_list')
								.css('overflow-y','scroll')
								.css('height', 'auto')
								.css('background-color', 'hsla(240, 83%, 47%, 0.2)')
								.css('max-height', '23vh')
							
							$(".top_list").slimscroll({
								height: "23vh",
						        size: "10px",
					        	allowPageScroll: true,
					   			touchScrollStep: 50,
					   			color: '#008000'
					       });
					
							<#-- build the Topic Filter list -->
							var sortedTopicList = data.topicFilter.topicDetailsList.sort(function(a, b) 
							{
								return sortList(a.title, b.title);
							})
							$.each( sortedTopicList, function( index, item){
							if(item.title!=null)
							{
								var topicDiv = 
										$( '<div/>' )
											.addClass('authorExplore')
											.attr({ 'id' : item.id })
											.css('padding-left','4px')
											.css('padding-right','4px')
											.append(
												$('<input/>')
													.attr('type','checkbox')
													.attr('name','topicCB')
													.attr('value', item.title)
													.attr({ 'id' : item.id })
												 )
											.append(
												$( '<span/>' )
													.addClass( 'name' )
													.html( " " +  item.title.toUpperCase() )
											)
												
											topSection
												.append( 
													topicDiv
												);
							}
						});
					<#-- CIRCLES FILTER -->
						if(data.circleFilter.circles.length!=0){
						
							var cirSectionHeader = $( '<span/>' ).html("CIRCLES (" + data.circleFilter.circles.length + ") :")
											.append('&nbsp;')
											.append(
												$('<span/>')
												.append(
													$('<input/>')
													.attr('type','checkbox')
													.attr('value', 'All')
													.on("click", function(){toggleCir(this)})
												 )
											);
							var cirSection = $( '<div/>' );
								
							filterContent.append(cirSectionHeader);
							filterContent.append(cirSection);
					
							cirSection.addClass('cir_list')
								.css('overflow-y','scroll')
								.css('height', 'auto')
								.css('background-color', '#f9f5f5')
								.css('max-height', '23vh')
							
							$(".cir_list").slimscroll({
								height: "23vh",
						        size: "10px",
					        	allowPageScroll: true,
					   			touchScrollStep: 50,
					   			color: '#008000'
					       });
					
							<#-- build the Publication Filter list -->
							var sortedCircleList = data.circleFilter.circles.sort(function(a, b) 
							{
								return sortList(a.name, b.name);
							})
							$.each(sortedCircleList , function( index, item){
							var circleDiv = 
									$( '<div/>' )
										.addClass('authorExplore')
										.attr({ 'id' : item.id })
										.css('padding-left','4px')
										.css('padding-right','4px')
										.append(
											$('<input/>')
												.attr('type','checkbox')
												.attr('name','circleCB')
												.attr('value', item.name)
												.attr({ 'id' : item.id })
											 )
										.append(
											$( '<span/>' )
												.addClass( 'name' )
												.html( " " +  item.name.toUpperCase() )
										)
										cirSection
											.append( 
												circleDiv
											);
									});
							}	
					}			
				}					
			});
			}
		};	
		
		function togglePub(source) {
		  checkboxesPub = document.getElementsByName('publicationCB');
		  for(var i=0, n=checkboxesPub.length;i<n;i++) {
		    checkboxesPub[i].checked = source.checked;
		  }
		}
		
		function toggleConf(source) {
		  checkboxesConf = document.getElementsByName('conferenceCB');
		  for(var i=0, n=checkboxesConf.length;i<n;i++) {
		    checkboxesConf[i].checked = source.checked;
		  }
		}
		
		function toggleTop(source) {
		  checkboxesTop = document.getElementsByName('topicCB');
		  for(var i=0, n=checkboxesTop.length;i<n;i++) {
		    checkboxesTop[i].checked = source.checked;
		  }
		}
		
		function toggleCir(source) {
		  checkboxesCir = document.getElementsByName('circleCB');
		  for(var i=0, n=checkboxesCir.length;i<n;i++) {
		    checkboxesCir[i].checked = source.checked;
		  }
		}
		
		function sortList(a,b){
			a = a.toLowerCase();
			b = b.toLowerCase();
			return (a < b) ? -1 : (a > b) ? 1 : 0;
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
	
			function checkBoxChange(){
			checkedPubValues = [];
			checkedConfValues = [];
			checkedTopValues = [];
			checkedCirValues = [];
		
			checkboxesPub = document.getElementsByName('publicationCB');
		  	for(var i=0; i<checkboxesPub.length;i++) {
		    	if(checkboxesPub[i].checked)
		    		checkedPubValues.push(checkboxesPub[i].id)
		  	}	
		
			checkboxesConf = document.getElementsByName('conferenceCB');
		  	for(var i=0; i<checkboxesConf.length;i++) {
		    	if(checkboxesConf[i].checked)
		    		checkedConfValues.push(checkboxesConf[i].id)
		  	}
		  	
		  	checkboxesTop = document.getElementsByName('topicCB');
		  	for(var i=0; i<checkboxesTop.length;i++) {
		    	if(checkboxesTop[i].checked)
		    		checkedTopValues.push(checkboxesTop[i].id)
		  	}
		  	
		  	checkboxesCir = document.getElementsByName('circleCB');
		  	for(var i=0; i<checkboxesCir.length;i++) {
		    	if(checkboxesCir[i].checked)
		    		checkedCirValues.push(checkboxesCir[i].id)
		  	}
			
			<#-- update visualize widget -->
			var yearFilterPresent = "true";
			var updateString = "?type="+objectType+"&dataList="+names+"&idList="+ids+"&visType="+visType+"&dataTransfer="+dataTransfer+"&checkedPubValues="+checkedPubValues+"&checkedConfValues="+checkedConfValues+"&checkedTopValues="+checkedTopValues+"&checkedCirValues="+checkedCirValues+"&startYear="+startYear+"&endYear="+endYear+"&yearFilterPresent="+yearFilterPresent;
			var visualizeWidget = $.PALM.boxWidget.getByUniqueName( 'explore_visualize' ); 
			visualizeWidget.options.queryString = updateString;
			$.PALM.boxWidget.refresh( visualizeWidget.element , visualizeWidget.options );
			
	
		}
</script>