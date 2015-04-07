
function handleExtended()
{
    // if the process is completed, decide to do with the returned data
    if (xmlHttp.readyState == 4)
    {
        // only if HTTP status is "OK"
        if (xmlHttp.status == 200)
        {
            try
            {
                document.getElementById('taskiface').innerHTML = xmlHttp.responseText;
            }
            catch(e)
            {
                // display the error message
                alert(e.toString() + "\n" + xmlHttp.responseText);
            }
        }
        else
        {
            alert("There was a problem retrieving the data:\n" + xmlHttp.statusText);
        }
    }
}

function getExtended()
{
    if (xmlHttp)
    {
        try
        {
            params = "?b=tasksajax&s=extended";

            xmlHttp.open("GET", "index.php" + params, true);
            xmlHttp.onreadystatechange = handleExtended;
            xmlHttp.send(null);
        }
        catch(e)
        {
            alert("Error: \n" + e.toString());
        }
    }
}

function load_task_iface()
{
    var tasktype = document.getElementById('tasktype').value;
    var taskiface = document.getElementById('taskiface');

    if (tasktype == 'DownloadRunModId') $("#autorun").show(250);
    else $("#autorun").hide(250);

    if (tasktype == 'DownloadRunExeUrl')
    {
        taskiface.innerHTML = "<td class='td_col_zag' width='30%'>Линк</td><td class='td_col_list' width='70%'><input style='width: 300px;' name='tTaskLink' type='text' size='50'></td>";
    }
    else if (tasktype == 'DownloadRunExeId' || tasktype == 'DownloadRunModId' || tasktype == 'DownloadUpdateMain')
    {
        getExtended();
    }
    else if (tasktype == 'WriteConfigString')
    {
        taskiface.innerHTML = "<td class='td_col_zag' width='30%'>Секция / Поле / Значение</td><td class='td_col_list' width='70%'>" +
            "<input style='width: 300px;' name='tSec' type='text' size='10'>&nbsp;&nbsp;<input style='width: 300px;' name='tName' type='text' size='15'>&nbsp;&nbsp;<input style='width: 300px;' name='tVal' type='text' size='50'></td>";
    }
    else if (tasktype == 'Command')
    {
        taskiface.innerHTML = "<td class='td_col_zag' width='30%'>Команда</td><td class='td_col_list' width='70%'><input style='width: 300px;' name='tTaskCommand' type='text' size='50'></td>";
    }
    else
    {
        taskiface.innerHTML = '';
    }

}

