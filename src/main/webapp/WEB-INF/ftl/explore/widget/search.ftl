<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" >
  	<div class="box-tools">
  	<div>
	    <div class="drop-down">
	    	<select id="selectDropDown" style="width:100%;font-size:12px" class="form-control" >
			  <option value="researchers">RESEARCHERS</option>
			  <option value="conferences">CONFERENCES</option>
			  <option value="publications">PUBLICATIONS</option>
			  <option value="topics">TOPICS</option>
			  <option value="circles">CIRCLES</option>
			</select>
	    </div>
	    
	    <div class="input-group" style="width: 100%;">
	      <input type="text" id="search_field" class="form-control input-sm pull-right" placeholder="Enter search text">
	      <div id="search_button" class="input-group-btn">
	        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
	      </div>
	    </div>
	   </div> 
  	</div>

	<div class="content-list">
    </div>
</div>
<div class="box-footer no-padding">
	<div class="col-xs-12  no-padding alignCenter">
		<div class="paging_simple_numbers">
			<ul id="researcherPaging" class="pagination marginBottom0">
				<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
				<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
				<#--<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">0</span></span></li>-->
				<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
				<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
			</ul>
		</div>
		<#--<span class="paging-info">Displaying records 0 - 0 of 0</span>-->
	</div>
</div>

<script>
	$( function(){
		
			<#-- add slim scroll -->
	      $(".content-list").slimscroll({
				height: "100%",
		        size: "5px",
	        	allowPageScroll: true,
	   			touchScrollStep: 50
		  });
		
		<#-- event for searching researcher -->
		var searchText = $( "#search_field" ).val();
		
		var itemType = "researchers";
		var url = "searchResearchers";
		<#-- generate unique id for progress log -->
		var uniqueSearchWidget = $.PALM.utility.generateUniqueId();
		var options ={
			source : "<@spring.url '/explore/' />"+url,
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
	
					dropDown = $( widgetElem ).find( "#selectDropDown" );
      				itemType = dropDown.val();
   					getURL(itemType);
   					
			},

			onRefreshDone: function(  widgetElem , data ){
			
				var targetContainer = $( widgetElem ).find( ".content-list" );
				targetContainer.html( "" );
				$( "#search_field" ).val("");
			
				<#-- pagging next -->
				$( "li.toNext" ).click( function(){
					if( !$( this ).hasClass( "disabled" ) )
						itemSearch( $( "#search_field" ).val().trim() , "next", data, targetContainer, widgetElem);
				});
				
				<#-- pagging prev -->
				$( "li.toPrev" ).click( function(){
					if( !$( this ).hasClass( "disabled" ) )
						itemSearch( $( "#search_field" ).val().trim() , "prev", data, targetContainer, widgetElem);
				});
				
				<#-- pagging to first -->
				$( "li.toFirst" ).click( function(){
					if( !$( this ).hasClass( "disabled" ) )
						itemSearch( $( "#search_field" ).val().trim() , "first", data, targetContainer, widgetElem);
				});
				
				<#-- pagging to end -->
				$( "li.toEnd" ).click( function(){
					if( !$( this ).hasClass( "disabled" ) )
						itemSearch( $( "#search_field" ).val().trim() , "end", data, targetContainer, widgetElem);
				});
				
				<#-- jump to specific page -->
				$( "select.page-number" ).change( function(){
					itemSearch( $( "#search_field" ).val() , $( this ).val(), data, targetContainer, widgetElem);
				});
				
			
			
				getData(data, targetContainer, widgetElem);
				
				<#-- search icon presed -->
				$( "#search_button" ).click( function(){
					//searchText = $( "#search_field" ).val();
					
					itemSearch( $( "#search_field" ).val() , "first", data, targetContainer, widgetElem);
					
					
				});
				
				
				<#-- drop down change event-->
				dropDown = $( widgetElem ).find( "#selectDropDown" );
				var sel = document.getElementById('selectDropDown');
   				sel.onchange = function() {
      				itemType = dropDown.val();
					
   					getURL(itemType);
	   				$( "#search_field" ).val("");
   					targetContainer.html( "" );
   					getData(data, targetContainer, widgetElem);
				}	
			}
		};	
		
		function getURL(itemType){
					if(itemType == "researchers"){
	   					url = "searchResearchers";
	   				}
	   				if(itemType == "conferences"){
	   					url = "searchConferences";
	   				}
	   				if(itemType == "publications"){
	   					url = "searchPublications";
	   				}
	   				if(itemType == "circles"){
	   					url = "searchCircles";
	   				}
	   				if(itemType == "topics"){
	   					url = "searchTopics";
	   				}
		}
		
		function getData(data, targetContainer, widgetElem){
		
			<#-- show pop up progress log -->
   			$.PALM.popUpMessage.create( "Loading "+itemType+" ..", { uniqueId:uniqueSearchWidget, popUpHeight:40, directlyRemove:false , polling:false});
   					
		
		
			<#-- Content List -->
				$.getJSON( "<@spring.url '/explore/' />"+url , function( data ) {
				
					<#-- remove  pop up progress log -->
					$.PALM.popUpMessage.remove( uniqueSearchWidget );
				
				
   				   	if(itemType == "researchers"){
   						
							if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no researchers found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No researchers found with query \"" + data.query + "\"" );
								return false;
							}
							
							if( data.count > 0 ){

								<#-- build the researcher list -->
								$.each( data.researchers, function( index, item){
								
									var researcherDiv = 
									$( '<div/>' )
										.addClass( 'authorExplore' )
										.attr({ 'id' : item.id });
										
									var researcherNav =
									$( '<div/>' )
										.addClass( 'nav' );
										
									var researcherDetail =
									$( '<div/>' )
										.addClass( 'detail' )
										.append(
											$( '<div/>' )
												.addClass( 'name' )
												.html( item.name )
										);
										
									researcherDiv
										.append(
											researcherNav
										).append(
											researcherDetail
										);
										
									if( !item.isAdded ){
										researcherDiv.css("display","none");
										data.count--;
									}
									
									if( typeof item.aff != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append('&nbsp;')	
											.append('&nbsp;')	
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-institution icon font-xs' )
											.append('&nbsp;')	
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.aff )
											)
										);

									researcherDetail
										.on("mouseover", function(){
										$( this ).parent().context.style.color="gray";
									});
									researcherDetail
										.on("mouseout", function(){
										$( this ).parent().context.style.color="black";
									});

									<#-- add click event -->
									researcherDetail
										.on( "click", function(){
													$( this ).parent().context.style.color="black";

												if( $.PALM.selected.record( "researcher", item.id, $( this ).parent() )){
													<#-- push history -->
												//	history.pushState(null, "Researcher " + item.name, "<@spring.url '/researcher' />?id=" + item.id + "&name=" + item.name );
												//	getAuthorDetails( item.id );
												}
												
												itemSelection(item.id, "researcher");
												
										} );
									
									targetContainer
										.append( 
											researcherDiv
										)
										.css({ "cursor":"pointer"});
									
								});
								setFooter(data, widgetElem);								
							}	
						}	//if			
						
						
					if(itemType == "conferences"){
   						
							if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no conferences/journals found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No conferences/journals found with query \"" + data.query + "\"" );
								//return false;
							}
							
							if( data.count > 0 ){
							
								// build the conference list
								$.each( data.eventGroups, function( index, itemEvent ){
									var eventItem = 
										$('<div/>')
										.addClass( "eventgroup-itemExplore" )
										.attr({ "data-id": itemEvent.id });
										
									<#-- hide unevaluated event -->
									if( !itemEvent.isAdded ){
										eventItem.css("display","none");
										data.count--;
									}
										
									<#-- event group -->
									var eventGroup = $( '<div/>' )
										.attr({'class':'eventgroup'})
										.attr({ "data-id": itemEvent.id });
										
									<#-- put event group into event item -->
									eventItem.append( eventGroup );
										
									<#-- event menu -->
									var eventNav = $( '<div/>' )
										.attr({'class':'nav'});
									
									<#-- append to event group -->
									eventGroup.append( eventNav );
									
									<#-- event detail -->
									var eventDetail = $('<div/>')
										.addClass( "detail" );
									
									<#-- append to event group -->
									eventGroup.append( eventDetail );
						
									<#-- event icon -->
									var conferenceType="fa fa-file-text-o";
									var eventIcon = $('<div/>').css("width","4%").css("float","left").append($('<i/>'));
									if( typeof itemEvent.type !== "undefined" ){
										if( itemEvent.type == "conference" )
											conferenceType = "fa fa-file-text-o";
										else if( itemEvent.type == "journal" )
											conferenceType = "fa fa-files-o";
										else if( itemEvent.type == "book" )
											conferenceType = "fa fa-book";
									}else{
										conferenceType = "fa fa-question";
									}
									

									<#-- title -->

									if( typeof itemEvent.type != 'undefined')
										eventDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append('&nbsp;')
											.append( 
												$( '<i/>' )
												.addClass( conferenceType )
													.append('&nbsp;')
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( typeof itemEvent.abbr != "undefined" ? itemEvent.name  +" (" + itemEvent.abbr + ")" : itemEvent.name )											
											)
										);
									
									
									<#-- append detail -->
									//eventDetail.append( eventIcon ).append('&nbsp;').append( eventName );

									<#-- add click event -->
									eventDetail.on( "click", function( e){
												if($( this ).parent().context.style.color=="gray")
												{
													$( this ).parent().context.style.color="black";
												}
												else
													$( this ).parent().context.style.color="gray";
										<#-- remove active class -->
										//if( $.PALM.selected.record(  "eventGroup", $( this ).parent().data( 'id' ) , $( this ).parent() )){
											//history.pushState(null, "Venue " + itemEvent.name, "<@spring.url '/venue' />?id=" + itemEvent.id + "&name=" + itemEvent.name );
											//getVenueGroupDetails( $( this ).parent().data( 'id' ) , eventGroup, itemEvent.name);
										//}
										itemSelection(itemEvent.id, "conference");
										
									});
									
									targetContainer.append( eventItem );
									
																	
								});
								
								setFooter(data, widgetElem);
							}	
						}	//if	
						
						if(itemType == "publications"){
   						
	   						if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no publications found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No publications found with query \"" + data.query + "\"" );
								return false;
							}
							
							if( data.count > 0 ){
							
								<#-- build the publication table -->
								$.each( data.publications, function( index, itemPublication ){

									var publicationItem = 
										$('<div/>')
										.addClass( "publicationExplore" )
										.attr({ "data-id": itemPublication.id });
										
									<#-- publication menu -->
									var pubNav = $( '<div/>' )
										.attr({'class':'nav'});
						
									<#-- publication icon -->
									var pubIcon = $('<i/>');
									if( typeof itemPublication.type !== "undefined" ){
										if( itemPublication.type == "Conference" )
											pubIcon.addClass( "fa fa-file-text-o bg-blue" ).attr({ "title":"Conference" });
										else if( itemPublication.type == "Workshop" )
											pubIcon.addClass( "fa fa-file-text-o bg-blue-dark" ).attr({ "title":"Workshop" });
										else if( itemPublication.type == "Journal" )
											pubIcon.addClass( "fa fa-files-o bg-red" ).attr({ "title":"Journal" });
										else if( itemPublication.type == "Book" )
											pubIcon.addClass( "fa fa-book bg-green" ).attr({ "title":"Book" });
										else if( itemPublication.type == "Informal" )
											pubIcon.addClass( "fa fa-file-text-o bg-gray" ).attr({ "title":"Other/Informal" });
									}else{
										pubIcon.addClass( "fa fa-question bg-purple" ).attr({ "title":"Unknown publication type" });
									}
									
									pubNav.append( pubIcon );
									

									publicationItem.append( pubNav );

									<#-- publication detail -->
									var pubDetail = $('<div/>').addClass( "detail" );
									<#-- title -->
									var pubTitle = $('<div/>').addClass( "title" ).html( itemPublication.title );


									<#-- append detail -->
									pubDetail.append( pubTitle );
										
									<#-- append to item -->
									publicationItem.append( pubDetail );

									<#-- add clcik event -->
									pubDetail.on( "click", function(){
										<#-- remove active class -->
										//if( $.PALM.selected.record( "publication", itemPublication.id, pubDetail.parent() )){
											<#-- push history -->
											//history.pushState( null, "Publication " + itemPublication.title, "<@spring.url '/publication' />?id=" + itemPublication.id + "&title=" + itemPublication.title);
											//getPublicationDetails( itemPublication.id);
										//}
										itemSelection(itemPublication.id, "publication");
										
									});

									targetContainer.append( publicationItem );
								
								
								});
								
								setFooter(data, widgetElem);
							}
	   						
	   						
						}	//if 
									
					}); //getJson
		}
		
		function itemSearch( query , jumpTo, data, targetContainer, widgetElem){
		
		<#--//find the element option-->
		$.each( $.PALM.options.registeredWidget, function(index, obj){
				var maxPage = parseInt($( obj.element ).find( "span.total-page" ).html()) - 1;
				if( jumpTo === "next")
					obj.options.page = obj.options.page + 1;
				else if( jumpTo === "prev")
					obj.options.page = obj.options.page - 1;
				else if( jumpTo === "first")
					obj.options.page = 0;
				else if( jumpTo === "end")
					obj.options.page = maxPage;
				else
					obj.options.page = parseInt( jumpTo ) - 1;
					
				$( obj.element ).find( ".paginate_button" ).each(function(){
					$( this ).removeClass( "disabled" );
				});
								
				if( obj.options.page === 0 ){
					$( obj.element ).find( "li.toFirst" ).addClass( "disabled" );
					$( obj.element ).find( "li.toPrev" ).addClass( "disabled" );
				} else if( obj.options.page > maxPage - 1){
					$( obj.element ).find( "li.toNext" ).addClass( "disabled" );
					$( obj.element ).find( "li.toEnd" ).addClass( "disabled" );
				}
				
				getURL(itemType);
					
				if( jumpTo === "first") // if new searching performed
					url = url + "?query=" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				else
					url = url + "?query=" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
	
		});
				targetContainer.html( "" );

				getData(data, targetContainer);
				
				setFooter(data, widgetElem);
				
	}
	
	function itemSelection(id, type){
	
		console.log("type here: "+ type)
		var queryString = "?id="+id+"&type="+type;
		
		<#-- update setup widget -->
		var stageWidget = $.PALM.boxWidget.getByUniqueName( 'explore_setup' ); 
		stageWidget.options.queryString = queryString;
		$.PALM.boxWidget.refresh( stageWidget.element , stageWidget.options );
		
		
		
	}
	
	
	function setFooter(data, widgetElem){
	
								var maxPage = Math.ceil(data.totalCount/data.maxresult);
								var $pageDropdown = $( widgetElem ).find( "select.page-number" );
								$pageDropdown.html( "" );
								<#-- set dropdown page -->
								for( var i=1;i<=maxPage;i++){
									$pageDropdown.append("<option value='" + i + "'>" + i + "</option>");
								}
								<#-- //enable bootstrap tooltip -->
								<#-- $( widgetElem ).find( "[data-toggle='tooltip']" ).tooltip(); -->
								
								<#--// set page number-->
								
								$pageDropdown.val( data.page + 1 );
								$( widgetElem ).find( "span.total-page" ).html( maxPage );
								var endRecord = (data.page + 1) * data.maxresult;
								if( data.page == maxPage - 1 ) 
								endRecord = data.totalCount;
						//	$( widgetElem ).find( "span.paging-info" ).html( "Displaying records " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.totalCount );
							
								if( maxPage == 1 ){
									$( widgetElem ).find( "li.toNext" ).addClass( "disabled" );
									$( widgetElem ).find( "li.toEnd" ).addClass( "disabled" );
								}
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
</script>