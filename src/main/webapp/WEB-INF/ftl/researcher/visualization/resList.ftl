<div class="box-body no-padding">
	<div class="box-tools">
	    <div class="input-group" style="width: 100%;">
	      <input type="text" id="researcher_search_field" name="researcher_search_field" class="form-control input-sm pull-right" placeholder="Search">
	      <div id="researcher_search_button" class="input-group-btn">
	        <button class="btn btn-sm btn-default"><i class="fa fa-search"></i></button>
	      </div>
	    </div>
  	</div>
  	
  	<div id="table-container-${wId}" class="table-container">

    </div>
</div>

<div class="box-footer no-padding">
	<div class="col-xs-12  no-padding alignCenter">
		<div class="paging_simple_numbers">
			<ul id="researcherPaging" class="pagination marginBottom0">
				<li class="paginate_button disabled toFirst"><a href="#"><i class="fa fa-angle-double-left"></i></a></li>
				<li class="paginate_button disabled toPrev"><a href="#"><i class="fa fa-caret-left"></i></a></li>
				<li class="paginate_button toCurrent"><span style="padding:3px">Page <select class="page-number" type="text" style="width:50px;padding:2px 0;" ></select> of <span class="total-page">20</span></span></li>
				<li class="paginate_button toNext"><a href="#"><i class="fa fa-caret-right"></i></a></li>
				<li class="paginate_button toEnd"><a href="#"><i class="fa fa-angle-double-right"></i></a></li>
			</ul>
		</div>
		<span class="paging-info">Displaying researchers 1 - 50 of 462</span>
	</div>
</div>

<script>
	$( function(){
	
		<#-- add slimscroll to table -->
		$("#table-container-${wId}").slimscroll({
			height: "100%",
	        size: "3px"
	    });
	    
	    <#-- event for searching researcher -->
	    $( "#researcher_search_field" )
	    .on( "keypress", function(e) {
			  if ( e.keyCode == 0 || e.keyCode == 13 || e.keyCode == 32 )
			    researcherSearch( $( this ).val().trim() , "first");
		}).on( "keydown", function(e) {
			  if( e.keyCode == 8 || e.keyCode == 46 )
			    if( $( "#researcher_search_field" ).val().length == 0 )
			    	researcherSearch( $( this ).val().trim() , "first");
		});

		<#-- icon search presed -->
		$( "#researcher_search_button" ).click( function(){
			researcherSearch( $( "#researcher_search_field" ).val().trim() , "first");
		});
		
		<#-- pagging next -->
		$( "li.toNext" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "next");
		});
		
		<#-- pagging prev -->
		$( "li.toPrev" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "prev");
		});
		
		<#-- pagging to first -->
		$( "li.toFirst" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "first");
		});
		
		<#-- pagging to end -->
		$( "li.toEnd" ).click( function(){
			if( !$( this ).hasClass( "disabled" ) )
				researcherSearch( $( "#researcher_search_field" ).val().trim() , "end");
		});
		
		<#-- jump to specific page -->
		$( "select.page-number" ).change( function(){
			researcherSearch( $( "#researcher_search_field" ).val() , $( this ).val() );
		});
		
		<#-- unique options in each widget -->
		var options ={
			source : "<@spring.url '/researcher/search' />",
			query: "",
			queryString : "",
			page:0,
			maxresult:50,
			onRefreshStart: function(  widgetElem  ){
						},
			onRefreshDone: function(  widgetElem , data ){
							var targetContainer = $( widgetElem ).find( "#table-container-${wId}" );
							<#-- remove previous list -->
							targetContainer.html( "" );
							
							var $pageDropdown = $( widgetElem ).find( "select.page-number" );
							$pageDropdown.find( "option" ).remove();
							
							if( data.count > 0 ){
								<#-- remove any remaing tooltip -->
								<#-- $( "body .tooltip" ).remove(); -->

								<#-- build the researcher list -->
								$.each( data.researcher, function( index, item){
									var researcherDiv = 
									$( '<div/>' )
										.addClass( 'palm_atr' )
										.attr({ 'id' : item.id })
										.append(
											$( '<div/>' )
											.addClass( 'palm_atr_photo fa fa-user' )
										).append(
											$( '<div/>' )
											.addClass( 'palm_atr_name' )
											.html( item.name )
										);
									if( typeof item.detail != 'undefined')
										researcherDiv.append(
											$( '<div/>' )
											.addClass( 'palm_atr_dtl' )
											.html( item.detail )
										);
									if( typeof item.aff != 'undefined')
										researcherDiv.append(
											$( '<div/>' )
											.addClass( 'palm_atr_aff' )
											.html( item.aff )
										);
									if( typeof item.citedBy != 'undefined')
										researcherDiv.append(
											$( '<div/>' )
											.addClass( 'palm_atr_ct' )
											.html( "Cited by : " + item.citedBy )
										);
									if( typeof item.photo != 'undefined'){
										researcherDiv
											.find( '.palm_atr_photo' )
											.removeClass( "fa fa-user" )
											.css({ 'font-size':'14px'})
											.append(
												$( '<img/>' )
													.attr({ 'src' : item.photo })
													.addClass( "palm_atr_img" )
											);
										
									}
									<#-- add clcik event -->
									researcherDiv
										.on( "click", function(){
											getAuthorDetails( $( this ).attr( 'id' ));
										} );
									
									targetContainer
										.append( 
											researcherDiv
										);
									<#-- put image position in center -->
									setTimeout(function() {
										if( typeof item.photo != 'undefined'){
											var imageAuthor = researcherDiv.find( "img:first" );
											imageAuthor.css({ "left" : (52 - imageAuthor.width())/2 + "px" });
										}
									}, 1000);
								});
								var maxPage = Math.ceil(data.count/data.maxresult);
								var $pageDropdown = $( widgetElem ).find( "select.page-number" );
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
								endRecord = data.count;
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying researchers " + ((data.page * data.maxresult) + 1) + " - " + endRecord + " of " + data.count );
							}
							else{
								$pageDropdown.append("<option value='0'>0</option>");
								$( widgetElem ).find( "span.total-page" ).html( 0 );
								$( widgetElem ).find( "span.paging-info" ).html( "Displaying researchers 0 - 0 of 0" );
								$( widgetElem ).find( "li.toNext" ).addClass( "disabled" );
								$( widgetElem ).find( "li.toEnd" ).addClass( "disabled" );
							}
						}
		};
		
		<#--// register the widget-->
		$.PALM.options.registeredWidget.push({
			"type":"${wType}",
			"group": "${wGroup}",
			"source": "${wSource}",
			"selector": "#widget-${wId}",
			"element": $( "#widget-${wId}" ),
			"options": options
		});
		
		<#--// adapt the height for first time-->
		$(document).ready(function() {
		    var bodyheight = $(window).height();
		    $("#table-container-${wId}").height(bodyheight - 192);
		});
		
		<#--// first time on load, list 50 researchers-->
		$.PALM.boxWidget.refresh( $( "#widget-${wId}" ) , options );
	});
	
	function researcherSearch( query , jumpTo ){
		<#--//find the element option-->
		$.each( $.PALM.options.registeredWidget, function(index, obj){
			if( obj.type === "RESEARCHER" && obj.group === "sidebar" ){
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
				
				if( jumpTo === "first") // if new searching performed
					obj.options.source = "<@spring.url '/researcher/search?query=' />" + query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				else
					obj.options.source = "<@spring.url '/researcher/search?query=' />" + obj.options.query + "&page=" + obj.options.page + "&maxresult=" + obj.options.maxresult;
				$.PALM.boxWidget.refresh( obj.element , obj.options );
			}
		});
	}
	
	<#-- when author list clciked --> 
	function getAuthorDetails( authorId ){
		<#-- put loading overlay -->
    	$.each( $.PALM.options.registeredWidget, function(index, obj){
				if( obj.type === "${wType}" && obj.group === "content" && obj.source === "INCLUDE"){
					obj.element.find( ".box" ).append( '<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>' );
				}
			});

		<#-- chack and fetch pzblication from academic network if necessary -->
		$.getJSON( "<@spring.url '/researcher/fetch?id=' />" + authorId + "&force=false", function( data ){
			<#-- refresh registered widget -->
		<#--
			$.each( $.PALM.options.registeredWidget, function(index, obj){
				if( obj.type === "${wType}" && obj.group === "content" && obj.source === "INCLUDE"){
					obj.options.queryString = "?id=" + authorId;
					$.PALM.boxWidget.refresh( obj.element , obj.options );
				}
			});
		-->
		});
	}
	
	<#--// for the window resize-->
	$(window).resize(function() {
	    var bodyheight = $(window).height();
	    $("#table-container-${wId}").height(bodyheight - 192);
	});
</script>