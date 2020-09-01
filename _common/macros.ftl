<#macro headSection title link>
  <section>
    <div class="col">
      <h3><a href="${link}">${title}</a></h3>
    </div>
    <div class="col">
      <p>
        <#nested>
      </p>
    </div>
  </section>
</#macro>
<#macro smallnav activeCheck url title>
  <li <#if activeCheck?has_content>class="top-active"</#if>>
    <a href="${url}" <#if activeCheck?has_content>class="x"</#if>>${title}</a>
    <#if activeCheck?has_content>
      <#nested >
    </#if>
  </li>
</#macro>
<#macro nav url title>
<li><a href="${url}">${title}</a>
  <#nested >
</li>
</#macro>
<#macro homePlace>
  {asd}
</#macro>
<#macro next title href>
  <div class="next pull-right">
    <a href="${href}" class="btn btn-info">Next: ${title}</a>
  </div>
</#macro>
