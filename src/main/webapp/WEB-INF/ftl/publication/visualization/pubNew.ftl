<div id="boxbody<#--${wId}-->" class="box-body">

		<table style="width:100%">
	        <tr style="background:transparent">
	            <td style="width:70%;padding:0">
	            	<span style="margin-top:5px;">Upload your publication (PDF format) : </span>
	            	<input id="fileupload" style="width:60%;max-width:none" type="file" name="files[]" data-url="<@spring.url '/publication/upload' />" multiple />
				</td>
	            <td style="padding:0">
	            	<div id="progress" class="progress" style="width:70%;display:none">
				        <div class="bar" style="width: 0%;"></div>
				    </div>
				</td>
	        </tr>
	    </table>

	 <form role="form" id="addPublication" action="<@spring.url '/publication/add' />" method="post">
		
		<#-- title -->
		<div class="form-group">
	      <label>Title</label>
	      <input type="text" id="title" name="title" class="form-control" placeholder="Publication">
	    </div>

		<#-- author -->
		<div class="form-group">
	      <label>Author</label>
	      <div id="authors" class="palm-tagsinput" tabindex="-1">
	      		<input type="text" value="" placeholder="Author fullname, separated by comma" />
	      </div>
	      <input type="hidden" id="author-list" name="keyword-list" value="">
	    </div>

		<#-- publication-date -->
		<div class="form-group">
			<label>Publication Date</label>
			<div class="input-group" style="width:120px">
				<div class="input-group-addon">
					<i class="fa fa-calendar"></i>
				</div>
	      		<input type="text" id="publication-date" name="publication-date" class="form-control" data-inputmask="'alias': 'mm/yyyy'" data-mask="">
			</div>
	    </div>

		<#-- Venue -->
		<div class="form-group">
          <label>Venue</label>
          <div style="width:100%">
	          <select id="venue-type" name="venue-type" class="form-control pull-left" style="width:120px">
	            <option value="conference">Conference</option>
	            <option value="journal">Journal</option>
	          </select>
	          <span style="display:block;overflow:hidden;padding:0 5px">
	          	<input type="text" id="venue" name="venue" class="form-control">
	          </span>
	      </div>
        </div>
        
        <#-- Venue properties -->
		<div class="form-group" style="width:100%;float:left">
			<div id="volume-container" class="col-xs-3 minwidth150Px" style="display:none">
				<label>Volume</label>
				<input type="text" id="volume" name="volume" class="form-control">
			</div>
			<div id="issue-container" class="col-xs-3 minwidth150Px" style="display:none">
				<label>Issue</label>
				<input type="text" id="issue" name="issue" class="form-control">
			</div>
			<div id="pages-container" class="col-xs-3 minwidth150Px">
				<label>Pages</label>
				<input type="text" id="pages" name="pages" class="form-control">
			</div>
			<div class="col-xs-3 minwidth150Px">
				<label>Publisher</label>
				<input type="text" id="publisher" name="publisher" class="form-control">
			</div>
		</div>

		<#-- abstract -->
		<div class="form-group">
	      <label>Abstract</label>
	      <textarea name="abstractText" id="abstractText" class="form-control" rows="3" placeholder="Abstract"></textarea>
	    </div>

		<#-- keyword -->
		<div class="form-group">
	      <label>Keywords</label>
	      <div id="keywords" class="palm-tagsinput" tabindex="-1">
	      		<input type="text" value="" placeholder="Keywords, separated by comma" />
	      </div>
	      <input type="hidden" id="keyword-list" name="keyword-list" value="">
	    </div>

		<#-- content -->
		<div class="form-group">
	      <label>Content</label>
	      <textarea name="contentText" id="contentText" class="form-control" rows="3" placeholder="Publication body/content"></textarea>
	    </div>

		<#-- references -->
		<div class="form-group">
	      <label>References</label>
	      <textarea name="referenceText" id="referenceText" class="form-control" rows="3" placeholder="References"></textarea>
	    </div>

		<#-- conference/journal -->
<#--		<div class="form-group">
	      <label>Venue</label>
	      <input type="text" id="venue" name="venue" class="form-control" placeholder="Venue">
	    </div>
-->
	</form>
</div>

<div class="box-footer">
	<button id="submit" type="submit" class="btn btn-primary">Submit</button>
</div>

<script>
	$(function(){

		<#-- multiple file-upload -->
    	convertToAjaxMultipleFileUpload( $( '#fileupload' ), $( '#progress' ) , $("#addPublication") );

		<#-- activate input mask-->
		$( "[data-mask]" ).inputmask();

		$( "#submit" ).click( function(){
			$("#addPublication").submit();
		});
		
		$( "#venue-type" ).change( function(){
			var selectionValue = $(this).val();
			if( selectionValue == "conference" ){
				$( "#volume-container,#issue-container" ).hide();
			} else if( selectionValue == "journal" ){
				$( "#volume-container,#issue-container" ).show();
			}
		});
		
		$("#venue").autocomplete({
		    source: function (request, response) {
		        $.ajax({
		            url: "<@spring.url '/venue/autocomplete' />",
		            dataType: "json",
		            data: {
						query: request.term
					},
		            success: function (data) {
		                response($.map(data, function(v,i){
		                    return {
		                            label: v.name,
		                            value: v.name,
		                            labelShort: v.abbr,
		                            url: v.url,
		                            type: v.type
		                           };
		                }));
		            }
		        });
		    },
			minLength: 3,
			select: function( event, ui ) {
				<#-- select appropriate vanue type -->
				$( '#venue-type' ).val( ui.item.type ).change();
				console.log( ui.item ?
					"Selected: " + ui.item.label :
					"Nothing selected, input was " + this.value);
			},
			open: function() {
				$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
			},
			close: function() {
				$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
			}
		});

		<#-- focus in and out on tag style -->
		$(".palm-tagsinput").on('focusin',function() {
		  	$( this ).addClass( "palm-tagsinput-focus" );
		});
		$(".palm-tagsinput").on('focusout',function() {
		  	$( this ).removeClass( "palm-tagsinput-focus" );
		});
		$(".palm-tagsinput").on('click',function() {
			$( this ).find( 'input' ).focus();
		});
		
		<#-- keyword tags -->
		$('#keywords input')
		.on('focusout',function(){    
			addKeyword( this );	
  		})
  		.on('keyup',function( e ){
   			if(/(188|13)/.test(e.which)) 
   				$(this).focusout().focus();
  		})
  		.on('keydown', function( e ){
  			if( this.value.length == 0)
    			return e.which !== 32;
		})
		.on('paste', function () {
			var element = this;
			setTimeout(function () {
				$( element ).focusout().focus();
			}, 100);
		});
		
		function addKeyword( inputElem ){
			<#-- allowed characters -->
    		var inputKeywords = inputElem.value.replace(/[^a-zA-Z0-9\+\-\.\#\s\,]/g,'');
    		
    		<#-- split by comma -->
			$.each( inputKeywords.split(","), function(index, inputKeyword ){
	    		<#-- remove multiple spaces -->
				inputKeyword = inputKeyword.replace(/ +(?= )/g,'').trim();
				if( inputKeyword.length > 2 && !isTagDuplicated( '#keyword-list', inputKeyword )) {
	      			$( inputElem ).before(
	      				$( '<span/>' )
	      					.addClass( "tag-item" )
	      					.html( inputKeyword )
	      					.append(
	      						$( '<i/>' )
	      						.addClass( "fa fa-times" )
	      						.click( function(){ 
	      							$( this ).parent().remove()
	      							updateInputList( '#keywords' )
	      						})
	      					)
	  				);
	  				<#-- update stored value -->
					updateInputList( '#keywords' );
	    		}
    		});
   			inputElem.value="";
		}
  		
  		function isTagDuplicated( inputListSelector, newText){
  			var keywordList = $( inputListSelector ).val().split(',');
  			if( $.inArray( newText , keywordList ) > -1 )
  				return true;
  			else
  				return false;
  		}
  		
  		function updateInputList( tagContainerSelector ){
  			var keywordList = "";
			$( tagContainerSelector ).find( "span" ).each(function(index, item){
				if( index > 0)
					keywordList += ",";
				keywordList += $( item ).text();
			});
			$( tagContainerSelector ).next( "input" ).val( keywordList );
  		}
  		
  		<#-- author -->
		$('#authors input')
		.on('focusout',function(){    
			<#-- allowed characters -->
    		var inputAuthor = this.value.replace(/[^a-zA-Z\s]/g,'');
    		<#-- remove multiple spaces -->
			inputAuthor = inputAuthor.replace(/ +(?= )/g,'').trim();
			if( inputAuthor.length > 3 && !isTagDuplicated( '#author-list', inputAuthor )) {
      			$(this).before(
      				$( '<span/>' )
      					.addClass( "tag-item" )
      					.html( inputAuthor )
      					.append(
      						$( '<i/>' )
      						.addClass( "fa fa-times" )
      						.click( function(){ 
      							$(this).parent().remove()
      							updateInputList( '#authors' )
      						})
      					)
  				);
  				<#-- update stored value -->
				updateInputList( '#authors' );
    		}
   			this.value="";   			
  		})
  		.on('keyup',function( e ){
   			if(/(188|13)/.test(e.which)) 
   				$(this).focusout().focus();
  		})
  		.on('keydown', function( e ){
  			if( this.value.length == 0)
    			return e.which !== 32;
    		else
    			return this.value.replace(/[^a-zA-Z\s]/g,'');
		})
		.on('paste', function () {
			
		});
	});

</script>