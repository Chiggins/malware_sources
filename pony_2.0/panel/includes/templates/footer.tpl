			</div>
	</div>

{if $authentication_success}
	<div class="push"></div>
</div>
   <div class="footer">
	<div id="foot">
    	<ul class="links">
{append var="nav_links" value="Главная" index=""}
{append var="nav_links" value="FTP пароли" index="ftp"}
{if $enable_http_mode && ($show_http_to_users || $priv_is_admin)}
{append var="nav_links" value="HTTP пароли" index="http"}
{/if}
{if $show_other_to_users || $priv_is_admin}
{append var="nav_links" value="Другие" index="other"}
{append var="nav_links" value="Статистика" index="stats"}
{/if}
{if $show_domains && ($show_domains_to_users || $priv_is_admin)}
{append var="nav_links" value="Домены" index="ping"}
{/if}
{append var="nav_links" value="Логи" index="log"}
{append var="nav_links" value="Отчеты" index="reports"}
{append var="nav_links" value="Управление" index="admin"}
{if $show_help_to_users || $priv_is_admin}
{append var="nav_links" value="Помощь" index="help"}
{/if}
{append var="nav_links" value="Выход" index="exit"}

{foreach from=$nav_links key=action item=contents name=nav}
			<li><a href="{$smarty.server.SCRIPT_NAME}?token={$token}{if $action != ""}&amp;action={$action}{/if}">{$contents}</a>{if !$smarty.foreach.nav.last} | {/if}</li>
{/foreach}
     	</ul>
    </div>
	</div>
{/if}

</body>
</html>