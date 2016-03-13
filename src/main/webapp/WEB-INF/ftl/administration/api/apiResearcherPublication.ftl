<form action="<@spring.url '/researcher/publicationList' />" method="post" role="form">

<#-- Info -->
<div class="form-group">
  <label class="info-label">Note:<br/>Get researcher ID from first API (Researcher Search). Use only ID from researcher which is added to PALM (isAdded:true)</label>  
</div>

<#-- Researcher Id -->
<div class="form-group">
  <label>id</label>  
  <input name="id" type="text" class="form-control input-md">
  <span class="help-block">Researcher ID gathered from Researcher Search API<</span>  
</div>

<#-- Query -->
<div class="form-group">
  <label>query</label>  
  <input name="query" type="text" class="form-control input-md">
  <span class="help-block">e.g. knowledge management</span>  
</div>

<#-- Year -->
<div class="form-group">
  <label>year</label>  
  <input name="year" type="text" value="all" class="form-control input-md">
  <span class="help-block">e.g. 2010</span>
</div>

<#-- Select Basic -->
<div class="form-group">
	<label>orderBy</label>
	<select name="orderBy" class="form-control">
		<option value="date">date</option>
		<option value="citation">number of citation</option>
	</select>
</div>

<#-- Text input-->
<div class="form-group">
	<label>startPage</label>  
	<input name="startPage" type="text" class="form-control" value="0">
	<span class="help-block">set the starting of records</span>  
</div>

<#-- Text input-->
<div class="form-group">
	<label>maxresult</label>  
	<input name="maxresult" type="text" class="form-control" value="30">
	<span class="help-block">number of maximum returned results</span>  
</div>

<#-- Button -->
<div class="form-group">
    <button onclick="$.PALM.api.submit( $(this) ); return false;" class="btn btn-primary">Execute</button>
</div>

<br/>

<#-- query -->
<div class="form-group">
	<label>API Query</label>
	<textarea class="form-control queryAPI" rows="2" readonly>
	</textarea>
</div>

<div class="form-group">
	<label>API Results</label>
	<pre class="textarea">
	</pre>
</div>
</form>
