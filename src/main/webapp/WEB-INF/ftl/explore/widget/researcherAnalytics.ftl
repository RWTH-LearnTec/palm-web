<@security.authorize access="isAuthenticated()">
	<#assign loggedUser = securityService.getUser() >
</@security.authorize>
<div id="boxbody-${wUniqueName}" class="box-body no-padding" style="height:40vh;overflow:hidden">
  	<div id="tab_va_topics" class="nav-tabs-custom">
        <ul class="nav nav-tabs">
			<li id="header_network">
				<a href="#tab_network" data-toggle="tab" aria-expanded="true">
					Network
				</a>
			</li>
			<li id="header_group">
				<a href="#tab_group" data-toggle="tab" aria-expanded="true">
					Group
				</a>
			</li>
			<li id="header_researcher_list">
				<a href="#tab_researcher_list" data-toggle="tab" aria-expanded="true">
					List
				</a>
			</li>
			<li id="header_researcher_comparison">
				<a href="#tab_researcher_comparison" data-toggle="tab" aria-expanded="true">
					Comparison
				</a>
			</li>
        </ul>
        <div class="tab-content">
			<div id="tab_network" class="tab-pane">
				<div id="canvas"></div>
			</div>
			<div id="tab_group" class="tab-pane">
			</div>
			<div id="tab_researcher_list" class="tab-pane" active>
				<div class="content-list">
				</div>
			</div>
			<div id="tab_researcher_comparison" class="tab-pane">
			</div>
        </div>
	</div>
</div>
<style>
#tab_network {
	  width: 50vw;
	  height: 40vh;
	  position: relative;
}    

#canvas {
      color: #fff;
      background: #fff;
	  position: absolute;
	  width: 100%;
	  height: 100%;
}
.label {
      position: absolute;
      top: 10px;
      left: 10px;
      z-index: 1;
      font-family: sans-serif;
    }
</style>
<script>
	$( function(){
		<#-- set target author id -->
		<#if targetId??>
			var targetId = "${targetId!''}";
		<#else>
			var targetId = "";
		</#if>
		<#if targetAdd??>
			var targetAdd = "${targetAdd!''}";
		<#else>
			var targetAdd = "";
		</#if>

	
		
	

		<#-- generate unique id for progress log -->
		var uniquePidResearcherWidget = $.PALM.utility.generateUniqueId();
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/explore/coAuthors' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
				<#-- show pop up progress log -->
				$.PALM.popUpMessage.create( "loading Researchers...", { uniqueId:uniquePidResearcherWidget, popUpHeight:40, directlyRemove:false});
						},
			onRefreshDone: function(  widgetElem , data ){	
			<#-- switch tab -->
			$('a[href="#tab_network"]').tab('show');
				

			<#-- initialize sigma.js renderer for gephi-->
			s = new sigma({
	            renderer: {
	              container: document.getElementById('canvas'),
	              type: 'canvas'
	            },
	            settings: sigma.setting
	        });

			<#-- gephi network -->
			sigma.parsers.gexf('<@spring.url '/resources/gexf/co-authors.gexf' />',s,function() {
				s.refresh();
			}); 
			s.refresh();


				<#-- List Tab -->
				$.getJSON( "<@spring.url '/explore/researchers' />" , function( data ) {
  							
  							
  							var targetContainer = $( widgetElem ).find( ".content-list" );
							<#-- remove  pop up progress log -->
							$.PALM.popUpMessage.remove( uniquePidResearcherWidget );

							<#-- remove previous list -->
							targetContainer.html( "" );
  							
							<#-- callout -->
							if( data.count == 0 ){
								if( typeof data.query === "undefined" || data.query == "" )
									$.PALM.callout.generate( targetContainer , "normal", "Currently no researchers found on PALM database" );
								else
									$.PALM.callout.generate( targetContainer , "warning", "Empty search results!", "No researchers found with query \"" + data.query + "\"" );
								return false;
							}
							
							if( data.count > 0 ){
								<#-- remove any remaing tooltip -->
								<#-- $( "body .tooltip" ).remove(); -->

								<#-- build the researcher list -->
								$.each( data.researchers, function( index, item){
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
									
									if( typeof item.status != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'status' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-briefcase icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.status )
											)
										);
									if( typeof item.aff != 'undefined')
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'affiliation' )
											.append( 
												$( '<i/>' )
												.addClass( 'fa fa-institution icon font-xs' )
											).append( 
												$( '<span/>' )
												.addClass( 'info font-xs' )
												.html( item.aff )
											)
										);
									if( typeof item.publicationsNumber != 'undefined'){
										var citedBy = 0;
										if( typeof item.citedBy !== "undefined" )
											citedBy = item.citedBy;
										researcherDetail.append(
											$( '<div/>' )
											.addClass( 'paper font-xs' )
											.html( "Publications: " + item.publicationsNumber + " || Cited by: " + citedBy )
										);
									}
										
									if( typeof item.photo != 'undefined'){
										researcherNav
											.append(
											$( '<div/>' )
												.addClass( 'photo' )
												.css({ 'font-size':'14px'})
												.append(
													$( '<img/>' )
														.attr({ 'src' : item.photo })
												)
											);
									} else {
										researcherNav
										.append(
											$( '<div/>' )
											.addClass( 'photo fa fa-user' )
										);
									}

									targetContainer
										.append( 
											researcherDiv
										);
									<#-- put image position in center -->
									setTimeout(function() {
										if( typeof item.photo != 'undefined'){
											var imageAuthor = researcherDiv.find( "img:first" );
											if( imageAuthor.width() > 30 )
												imageAuthor.css({ "left" : (52 - imageAuthor.width())/2 + "px" });
										}
									}, 1000);
									

								}); <#-- for each-->
							} <#-- if-->
						}); <#-- json-->
				}
		};
		
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