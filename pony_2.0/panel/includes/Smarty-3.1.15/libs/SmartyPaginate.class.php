<?php

/**
 * Project:     SmartyPaginate: Pagination for the Smarty Template Engine
 * File:        SmartyPaginate.class.php
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * @link http://www.phpinsider.com/php/code/SmartyPaginate/
 * @copyright 2001-2005 New Digital Group, Inc.
 * @author Monte Ohrt <monte at newdigitalgroup dot com>
 * @package SmartyPaginate
 * @version 1.6
 */


class SmartyPaginate {

    /**
     * Class Constructor
     */
    function SmartyPaginate() { }

    /**
     * initialize the session data
     *
     * @param string $id the pagination id
     * @param string $formvar the variable containing submitted pagination information
     */
    public static function connect($id = 'default', $formvar = null) {
        if(!isset($_SESSION['SmartyPaginate'][$id])) {
            SmartyPaginate::reset($id);
        }
        
        // use $_GET by default unless otherwise specified
        $_formvar = isset($formvar) ? $formvar : $_GET;
        
        // set the current page
        $_total = SmartyPaginate::getTotal($id);
        if(isset($_formvar[SmartyPaginate::getUrlVar($id)]) && $_formvar[SmartyPaginate::getUrlVar($id)] > 0 && (!isset($_total) || $_formvar[SmartyPaginate::getUrlVar($id)] <= $_total))
            $_SESSION['SmartyPaginate'][$id]['current_item'] = $_formvar[$_SESSION['SmartyPaginate'][$id]['urlvar']];
    }

    /**
     * see if session has been initialized
     *
     * @param string $id the pagination id
     */
    public static function isConnected($id = 'default') {
        return isset($_SESSION['SmartyPaginate'][$id]);
    }    
        
    /**
     * reset/init the session data
     *
     * @param string $id the pagination id
     */
    public static function reset($id = 'default') {
        $_SESSION['SmartyPaginate'][$id] = array(
            'item_limit' => 10,
            'item_total' => null,
            'current_item' => 1,
            'urlvar' => 'next',
            'url' => $_SERVER['PHP_SELF'],
            'prev_text' => 'prev',
            'next_text' => 'next',
            'first_text' => 'first',
            'last_text' => 'last'
            );
    }
    
    /**
     * clear the SmartyPaginate session data
     *
     * @param string $id the pagination id
     */
    public static function disconnect($id = null) {
        if(isset($id))
            unset($_SESSION['SmartyPaginate'][$id]);
        else
            unset($_SESSION['SmartyPaginate']);
    }

    /**
     * set maximum number of items per page
     *
     * @param string $id the pagination id
     */
    public static function setLimit($limit, $id = 'default') {
        if(!preg_match('!^\d+$!', $limit)) {
            trigger_error('SmartyPaginate setLimit: limit must be an integer.');
            return false;
        }
        settype($limit, 'integer');
        if($limit < 1) {
            trigger_error('SmartyPaginate setLimit: limit must be greater than zero.');
            return false;
        }
        $_SESSION['SmartyPaginate'][$id]['item_limit'] = $limit;
    }    

    /**
     * get maximum number of items per page
     *
     * @param string $id the pagination id
     */
    public static function getLimit($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['item_limit'];
    }    
            
    /**
     * set the total number of items
     *
     * @param int $total the total number of items
     * @param string $id the pagination id
     */
    public static function setTotal($total, $id = 'default') {
        if(!preg_match('!^\d+$!', $total)) {
            trigger_error('SmartyPaginate setTotal: total must be an integer.');
            return false;
        }
        settype($total, 'integer');
        if($total < 0) {
            trigger_error('SmartyPaginate setTotal: total must be positive.');
            return false;
        }
        $_SESSION['SmartyPaginate'][$id]['item_total'] = $total;
    }

    /**
     * get the total number of items
     *
     * @param string $id the pagination id
     */
    public static function getTotal($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['item_total'];
    }    

    /**
     * set the url used in the links, default is $PHP_SELF
     *
     * @param string $url the pagination url
     * @param string $id the pagination id
     */
    public static function setUrl($url, $id = 'default') {
        $_SESSION['SmartyPaginate'][$id]['url'] = $url;
    }

    /**
     * get the url variable
     *
     * @param string $id the pagination id
     */
    public static function getUrl($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['url'];
    }    
    
    /**
     * set the url variable ie. ?next=10
     *                           ^^^^
     * @param string $url url pagination varname
     * @param string $id the pagination id
     */
    public static function setUrlVar($urlvar, $id = 'default') {
        $_SESSION['SmartyPaginate'][$id]['urlvar'] = $urlvar;
    }

    /**
     * get the url variable
     *
     * @param string $id the pagination id
     */
    public static function getUrlVar($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['urlvar'];
    }    
        
    /**
     * set the current item (usually done automatically by next/prev links)
     *
     * @param int $item index of the current item
     * @param string $id the pagination id
     */
    public static function setCurrentItem($item, $id = 'default') {
        $_SESSION['SmartyPaginate'][$id]['current_item'] = $item;
    }

    /**
     * get the current item
     *
     * @param string $id the pagination id
     */
    public static function getCurrentItem($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['current_item'];
    }    

    /**
     * get the current item index
     *
     * @param string $id the pagination id
     */
    public static function getCurrentIndex($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['current_item'] - 1;
    }    
    
    /**
     * get the last displayed item
     *
     * @param string $id the pagination id
     */
    public static function getLastItem($id = 'default') {
        $_total = SmartyPaginate::getTotal($id);
        $_limit = SmartyPaginate::getLimit($id);
        $_last = SmartyPaginate::getCurrentItem($id) + $_limit - 1;
        return ($_last <= $_total) ? $_last : $_total; 
    }    
    
    /**
     * assign $paginate var values
     *
     * @param smarty &$smarty the smarty object reference
     * @param string $var the name of the assigned var
     * @param string $id the pagination id
     */
    public static function assign(&$smarty, $var = 'paginate', $id = 'default') {
        if(is_object($smarty) && (strtolower(get_class($smarty)) == 'smarty' || is_subclass_of($smarty, 'smarty'))) {
            $_paginate['total'] = SmartyPaginate::getTotal($id);
            $_paginate['first'] = SmartyPaginate::getCurrentItem($id);
            $_paginate['last'] = SmartyPaginate::getLastItem($id);
            $_paginate['page_current'] = ceil(SmartyPaginate::getLastItem($id) / SmartyPaginate::getLimit($id));
            $_paginate['page_total'] = ceil(SmartyPaginate::getTotal($id)/SmartyPaginate::getLimit($id));
            $_paginate['size'] = $_paginate['last'] - $_paginate['first'];
            $_paginate['url'] = SmartyPaginate::getUrl($id);
            $_paginate['urlvar'] = SmartyPaginate::getUrlVar($id);
            $_paginate['current_item'] = SmartyPaginate::getCurrentItem($id);
            $_paginate['prev_text'] = SmartyPaginate::getPrevText($id);
            $_paginate['next_text'] = SmartyPaginate::getNextText($id);
            $_paginate['limit'] = SmartyPaginate::getLimit($id);
            
            $_item = 1;
            $_page = 1;
            while($_item <= $_paginate['total'])           {
                $_paginate['page'][$_page]['number'] = $_page;   
                $_paginate['page'][$_page]['item_start'] = $_item;
                $_paginate['page'][$_page]['item_end'] = ($_item + $_paginate['limit'] - 1 <= $_paginate['total']) ? $_item + $_paginate['limit'] - 1 : $_paginate['total'];
                $_paginate['page'][$_page]['is_current'] = ($_item == $_paginate['current_item']);
                $_item += $_paginate['limit'];
                $_page++;
            }
            $smarty->assign($var, $_paginate);
        } else {
            trigger_error("SmartyPaginate: [assign] I need a valid Smarty object.");
            return false;            
        }        
    }    

    
    /**
     * set the default text for the "previous" page link
     *
     * @param string $text index of the current item
     * @param string $id the pagination id
     */
    public static function setPrevText($text, $id = 'default') {
        $_SESSION['SmartyPaginate'][$id]['prev_text'] = $text;
    }

    /**
     * get the default text for the "previous" page link
     *
     * @param string $id the pagination id
     */
    public static function getPrevText($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['prev_text'];
    }    
    
    /**
     * set the text for the "next" page link
     *
     * @param string $text index of the current item
     * @param string $id the pagination id
     */
    public static function setNextText($text, $id = 'default') {
        $_SESSION['SmartyPaginate'][$id]['next_text'] = $text;
    }
    
    /**
     * get the default text for the "next" page link
     *
     * @param string $id the pagination id
     */
    public static function getNextText($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['next_text'];
    }    

    /**
     * set the text for the "first" page link
     *
     * @param string $text index of the current item
     * @param string $id the pagination id
     */
    public static function setFirstText($text, $id = 'default') {
        $_SESSION['SmartyPaginate'][$id]['first_text'] = $text;
    }
    
    /**
     * get the default text for the "first" page link
     *
     * @param string $id the pagination id
     */
    public static function getFirstText($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['first_text'];
    }    
    
    /**
     * set the text for the "last" page link
     *
     * @param string $text index of the current item
     * @param string $id the pagination id
     */
    public static function setLastText($text, $id = 'default') {
        $_SESSION['SmartyPaginate'][$id]['last_text'] = $text;
    }
    
    /**
     * get the default text for the "last" page link
     *
     * @param string $id the pagination id
     */
    public static function getLastText($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['last_text'];
    }    
    
    /**
     * set default number of page groupings in {paginate_middle}
     *
     * @param string $id the pagination id
     */
    public static function setPageLimit($limit, $id = 'default') {
        if(!preg_match('!^\d+$!', $limit)) {
            trigger_error('SmartyPaginate setPageLimit: limit must be an integer.');
            return false;
        }
        settype($limit, 'integer');
        if($limit < 1) {
            trigger_error('SmartyPaginate setPageLimit: limit must be greater than zero.');
            return false;
        }
        $_SESSION['SmartyPaginate'][$id]['page_limit'] = $limit;
    }    

    /**
     * get default number of page groupings in {paginate_middle}
     *
     * @param string $id the pagination id
     */
    public static function getPageLimit($id = 'default') {
        return $_SESSION['SmartyPaginate'][$id]['page_limit'];
    }
            
    /**
     * get the previous page of items
     *
     * @param string $id the pagination id
     */
    public static function _getPrevPageItem($id = 'default') {
        
        $_prev_item = $_SESSION['SmartyPaginate'][$id]['current_item'] - $_SESSION['SmartyPaginate'][$id]['item_limit'];
        
        return ($_prev_item > 0) ? $_prev_item : false; 
    }    

    /**
     * get the previous page of items
     *
     * @param string $id the pagination id
     */
    public static function _getNextPageItem($id = 'default') {
                
        $_next_item = $_SESSION['SmartyPaginate'][$id]['current_item'] + $_SESSION['SmartyPaginate'][$id]['item_limit'];
        
        return ($_next_item <= $_SESSION['SmartyPaginate'][$id]['item_total']) ? $_next_item : false; 
    }    
    
                
            
}

?>
