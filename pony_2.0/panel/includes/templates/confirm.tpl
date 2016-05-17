{if !isset($confirm_code)}
	{assign var='confirm_code' value=''}
{/if}

{* add CSRF token *}

{if isset($no_code) && strlen($no_code)}
	{assign var='no_code' value={$no_code nofilter}|cat:"&amp;token={$token}"}
{/if}

{if isset($yes_code) && strlen($yes_code)}
	{assign var='yes_code' value={$yes_code nofilter}|cat:"&amp;token={$token}"}
{/if}

		<h4 class="achtung_header">{$msg|default:"Вы уверены?"}</h4>
		<div style="height:40px;">
                <div class="buttons">
					<a href="{$yes_code|default:({$smarty.server.SCRIPT_NAME}|cat:"?token={$token}") nofilter}" class="positive" style="width:50px">
					    <img src="includes/design/images/accept.png" alt="" />
					    Да
					</a>
					<a href="{$no_code|default:({$smarty.server.SCRIPT_NAME}|cat:"?token={$token}") nofilter}" class="negative" style="width:50px">
					    <img src="includes/design/images/cross.png" alt="" /> 
					    Нет
					</a>
	    		</div>
	    </div>
