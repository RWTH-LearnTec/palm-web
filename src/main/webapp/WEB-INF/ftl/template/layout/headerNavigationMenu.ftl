<#assign security=JspTaglibs["http://www.springframework.org/security/tags"] />
<li<#if link?? && link == "researcher"> class="open"</#if>>
	<a href="<@spring.url '/researcher' />" data-toggle="tooltip" data-placement="bottom" data-original-title="Researchers">
		<i class="fa fa-users"></i>
		<strong> Researchers</strong>
	</a>
</li>
<li<#if link?? && link == "publication"> class="open"</#if>>
	<a href="<@spring.url '/publication' />" data-toggle="tooltip" data-placement="bottom" data-original-title="Publications">
		<i class="fa fa-file-text-o"></i>
		<strong> Publications</strong>
	</a>
</li>
<li<#if link?? && link == "venue"> class="open"</#if>>
	<a href="<@spring.url '/venue' />"  data-toggle="tooltip" data-placement="bottom" data-original-title="Conferences">
		<i class="fa fa-globe"></i>
		<strong> Conferences</strong>
	</a>
</li>
<li<#if link?? && link == "circle"> class="open"</#if>>
	<a href="<@spring.url '/circle' />"  data-toggle="tooltip" data-placement="bottom" data-original-title="Circles">
		<i class="fa fa-circle-o"></i>
		<strong> Circles</strong>
	</a>
</li>