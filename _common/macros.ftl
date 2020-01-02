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
