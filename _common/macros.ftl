<#macro headSection title link>
  <section class="g2">
    <div class="c1">
      <h3><a href="${link}">${title}</a></h3>
    </div>
    <div class="c2">
      <p>
        <#nested>
      </p>
    </div>
  </section>
</#macro>
