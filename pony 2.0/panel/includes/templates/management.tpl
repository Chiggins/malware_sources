{if {$smarty.request.routine|default:''} == 'confirm_delete'}
	{if $priv_is_admin}
		{assign var='msg' value="Вы уверены, что хотите удалить пользователя '"|cat:{$smarty.request.username|default:''}|cat:"'?"}
		{assign var='yes_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=admin&amp;routine=delete&amp;user_id="|cat:{$smarty.request.user_id|default:''}}
		{assign var='no_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=admin"}
		{include file='confirm.tpl'}
	{else}
		{include file='error.tpl' err_code='ERR_NOT_ENOUGH_PRIVILEGES'}
	{/if}
{elseif {$smarty.request.routine|default:''} == 'confirm_rebuild_tables'}
	{if $priv_is_admin}
		{assign var='msg' value="Вы уверены, что хотите пересоздать таблицы и стереть все данные?"}
		{assign var='yes_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=admin&amp;routine=rebuild_tables"}
		{assign var='no_code' value={$smarty.server.SCRIPT_NAME}|cat:"?action=admin"}
		{include file='confirm.tpl'}
	{else}
		{include file='error.tpl' err_code='ERR_NOT_ENOUGH_PRIVILEGES'}
	{/if}
{/if}		

	<div id="arrow_nav">
	{if $priv_is_admin}
		<a href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=admin&amp;routine=server_settings_form">Настройки сервера</a><br />
		<a href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=admin&amp;routine=new_user_form">Добавить нового пользователя</a><br />
		<a href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=admin&amp;routine=optimize_tables">Оптимизировать (сжать) таблицы MySQL</a><br />
		<a href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=admin&amp;routine=confirm_rebuild_tables">Пересоздать таблицы MySQL</a><br />
	{/if}
	<a href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=admin&amp;routine=change_pass_form">Изменить пароль доступа к панели</a><br />
	</div><br />

{if {$smarty.request.routine|default:''} == 'server_settings_form'}
	{if $priv_is_admin}
		<div id="user_form">
            <h2 class="settings">Настройки сервера</h2>

            <form name="settings_frm" action="{$smarty.server.SCRIPT_NAME}" method="get">
            	<input type="submit" style="position:absolute;left:-10000px;top:-10000px;" />
            	<input type="hidden" name="token" value="{$token}" />
                <label class="formTxt">Пароль для дешифровки отчетов</label>
                <input type="text" name="report_password" value="{$report_password}" class="txtBox" /> 
                <input type="hidden" name="action" value="admin" />
                <input type="hidden" name="routine" value="update_server_settings" />

				<input style="margin-left:20px; margin-top: 6px; float: left; margin-right: 3px;" type="checkbox" id="sftp_user" name="sftp_user" value="1" {if $sftp_user == '1'}checked="checked"{/if} /><label for="sftp_user" class="formTxt"> Определять SFTP по username (root)</label>
				<div style="clear:both"></div>
				<input style="margin-left:20px; margin-top: 6px; float: left; margin-right: 3px;" type="checkbox" id="sftp_port" name="sftp_port" value="1" {if $sftp_port == '1'}checked="checked"{/if} /><label for="sftp_port" class="formTxt"> Определять SFTP по 22 порту</label>
				<div style="clear:both"></div>
				<input style="margin-left:20px; margin-top: 6px; float: left; margin-right: 3px;" type="checkbox" id="sftp_protocol" name="sftp_protocol" value="1" {if $sftp_protocol == '1'}checked="checked"{/if} /><label for="sftp_protocol" class="formTxt"> Определять SFTP по протоколу в клиенте</label>

                <div class="buttons" style="float:right;margin-right:40px;margin-top:10px;">
				    <button onclick="javascript:document.settings_frm.submit();" class="positive" style="width:110px;">
				        <img src="includes/design/images/disk.png" alt="" /> 
				        Сохранить
					</button>
				</div>
            </form>
            </div>
	{else}
		{include file='error.tpl' err_code='ERR_NOT_ENOUGH_PRIVILEGES'}
	{/if}
{elseif {$smarty.request.routine|default:''} == 'change_pass_form'}
		<div id="user_form">
            <h2 class="edit">Изменить пароль доступа</h2>

            <form name="pass_change_frm" action="{$smarty.server.SCRIPT_NAME}" method="get">
            	<input type="hidden" name="token" value="{$token}" />
                <label class="formTxt">Текущий пароль</label>
                <input type="password" name="current_password" value="" class="txtBox" /> 
                <label class="formTxt">Новый пароль</label>
                <input type="password" name="new_password" value="" class="txtBox" /> 
                <label class="formTxt">Подтверждение пароля</label>
                <input type="password" name="confirm_password" value="" class="txtBox" /> 
                <input type="hidden" name="action" value="admin" />
                <input type="hidden" name="routine" value="change_password" />
                <div class="buttons" style="float:right;margin-right:40px;margin-top:10px;">
				    <button onclick="javascript:document.pass_change_frm.submit();" class="positive" style="width:110px;">
				        <img src="includes/design/images/disk.png" alt="" /> 
				        Сохранить
					</button>
				</div>
            </form>
            </div>
{elseif {$smarty.request.routine|default:''} == 'new_user_form'}
	{if $priv_is_admin}
			<div id="user_form">
            	<h2>Добавить пользователя</h2>

                <form name="new_user_frm" action="{$smarty.server.SCRIPT_NAME}" method="get">
            		<input type="hidden" name="token" value="{$token}" />
                	<label class="formTxt">Логин</label>
                	<input type="text" name="new_login" value="" class="txtBox" />
                	<label class="formTxt">Пароль</label>
                	<input type="password" name="new_password" value="" class="txtBox" />
                	<label class="formTxt">Привилегии</label>
                	<select name="privileges" size="1">
                	<option value="user_all">user_all</option>
                	<option value="user_view_only">user_view_only</option>
                	</select>
                	<input type="hidden" name="action" value="admin" />
                	<input type="hidden" name="routine" value="add" />
                   	<div class="buttons" style="float:right;margin-right:40px;">
				    	<button onclick="javascript:document.new_user_frm.submit();" class="positive" style="width:110px;">
				        	<img src="includes/design/images/add.png" alt="" /> 
				        	Добавить
						</button>
					</div>
                </form>
                </div>
	{else}
		{include file='error.tpl' err_code='ERR_NOT_ENOUGH_PRIVILEGES'}
	{/if}
{elseif {$smarty.request.routine|default:''} == 'edit_form'}
	{if $priv_is_admin}
		{if isset($user_data) && is_array($user_data)}
				<div id="user_form">
            		<h2 class="edit">Редактировать данные</h2>

	                <form name="user_edit_frm" action="{$smarty.server.SCRIPT_NAME}" method="get">
            			<input type="hidden" name="token" value="{$token}" />
                		<label class="formTxt">Логин</label>
                		<input type="text" disabled="disabled" value="{$user_data.username}" class="txtBox" /> 
                		<label class="formTxt">Пароль</label>
                		<input type="password" name="new_password" value="current_HASH_value" class="txtBox" /> 
                		<label class="formTxt">Привилегии</label>
                		<select name="privileges" size="1">
                		<option value="user_all"{if $user_data.privileges=='user_all'} selected="selected"{/if}>user_all</option>
                		<option value="user_view_only"{if $user_data.privileges=='user_view_only'} selected="selected"{/if}>user_view_only</option>
                		
                	</select>
                		<input type="hidden" name="user_id" value="{$user_data.user_id}" />
                		<input type="hidden" name="action" value="admin" />
                		<input type="hidden" name="routine" value="edit" />
                   		<div class="buttons" style="float:right;margin-right:40px;">
				    		<button onclick="javascript:document.user_edit_frm.submit();" class="positive" style="width:110px;">
						        <img src="includes/design/images/disk.png" alt="" /> 
						        Сохранить
							</button>
						</div>
	                </form>
	                </div>
		{else}
			{include file='error.tpl' err_code=''}
		{/if}
	{else}
		{include file='error.tpl' err_code='ERR_NOT_ENOUGH_PRIVILEGES'}
	{/if}
{/if}


{if $priv_is_admin && count($user_list) > 0}
	<h4>Пользователи</h4>
	<table id="table_user_list" width="500px" cellspacing="0" summary="User list">
	<tr>
	<th width="25%">Пользователь</th>
	<th width="25%">Привилегии</th>
	<th width="50%">Действия</th>
	</tr>
	{foreach from=$user_list item=user}
		<tr>
		<td style="padding-bottom:2px"><img style="margin-top:-2px;vertical-align:middle;" src="includes/design/images/user_icon.png" alt="" width="16" height="16" /> {$user.username}</td>
		<td>{$user.privileges}</td>
		<td><a href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=admin&amp;routine=edit_form&amp;user_id={$user.user_id}">Редактировать данные</a> | 
		<a href="{$smarty.server.SCRIPT_NAME}?token={$token}&amp;action=admin&amp;routine=confirm_delete&amp;user_id={$user.user_id}&amp;username={$user.username}">Удалить</a></td>
		</tr>
	{/foreach}
	</table>
{/if}