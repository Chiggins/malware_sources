{if {$smarty.request.routine|default:''} == 'delete_confirm'}
	{assign var='msg' value="Вы уверены, что хотите удалить домен '"|cat:{$smarty.request.domain|default:''}|cat:"'?"}
	{assign var='yes_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=ping&amp;routine=delete&amp;domain_id="|cat:{$smarty.request.domain_id|default:''}}
	{assign var='no_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=ping"}
	{include file='confirm.tpl'}
{/if}
		<div id="ping_form">
            		<h2>Управление доменами</h2>
	                <div style='height:30px'>
	                	<form name="add_frm" action="{$smarty.server.SCRIPT_NAME}" method="get">
							<input type="submit" style="position:absolute;left:-10000px;top:-10000px;" />
	                		<label class="formTxt">Новый</label>
	                		<input type="text" name="domain" value="http://" class="txtBox" /> 
	                		<input type="hidden" name="action" value="ping" />
	                		<input type="hidden" name="token" value="{$token}" />
	                		<input type="hidden" name="routine" value="add" />
	                   		<div class="buttons">
					    		<button onclick="javascript:document.add_frm.submit();" class="positive" style="width:110px;">
					        		<img src="includes/design/images/add.png" alt="" /> 
					        		Добавить
								</button>
							</div>
						</form>
					</div>
		{foreach from=$domain_list item=domain}
    				<div>
    					<form name="del_frm{$domain.domain_id}" action="{$smarty.server.SCRIPT_NAME}" method="get">
    						<input type="submit" style="position:absolute;left:-10000px;top:-10000px;" />
                			<p id="chk_status_{$domain.domain_id}"><span class="wait"></span></p>
                			<input type="text" name="domain" value="{$domain.url}" readonly="readonly" class="txtBoxGrey" />
                			<input type="hidden" name="token" value="{$token}" />
                			<input type="hidden" name="domain_id" value="{$domain.domain_id}" />
                			<input type="hidden" name="action" value="ping" />
                			<input type="hidden" name="routine" value="delete_confirm" />
                    		<div class="buttons">
					    		<button onclick="javascript:document.del_frm{$domain.domain_id}.submit();" class="negative" style="width:110px;">
					        		<img src="includes/design/images/cross.png" alt="" /> 
					        		Удалить
								</button>
	    					</div>
		                </form>
					</div>
		{/foreach}
		</div>
