jQuery.extend({
	/** Specify the default settings used by jPager3k.
	 * New settings override the old ones, others are preserved
	 * @param {?String}	mode	The mode
	 * @param {?Object}	paging	Paging settings
	 * @param {?Object}	sets	Pager settings
	 */
	jPager3k: function(mode, paging, sets){
		jQuery.jPager3k.onLoadRegged = false;
		if (!jQuery.jPager3k.mode) jQuery.jPager3k.mode = 'auto';
		if (!jQuery.jPager3k.paging) jQuery.jPager3k.paging = {};
		if (!jQuery.jPager3k.sets) jQuery.jPager3k.sets = {};

		jQuery.extend(true, jQuery.jPager3k, {
				mode: mode,
				paging: paging,
				sets: sets
				});
		}
	});

/* Set the default settings.
 * They are overriden by the function call which, in turn, can be overriden by the tag attributes
 */
jQuery.jPager3k(
				'auto', // The default pager mode
				{ // `paging`: Specific paging settings
					first: 1, // The first page id
					step: +1, // Page incremental step
					last: 100, // The last page id
					current: 1, // The current page id
					url: '?page=%page%', // Page hyperlink template
					lang: 'en' // The language to use
					},
				{ // `sets`: Pager settings
					init: '.jPager3k', // Automatically create paginators matching this selector. Set `null` to disable
					tags: { // Varous tag-related settings
						link: '<li><a href="%url%">%N%</a></li>', 	// Template for links generator
						current_class: 'this',	// ClassName to append to the current page hyperlink.
											// In 'manual' mode, jPager3k scans for it to determine the current page
						current_wrap: '<span></span>'	// Wrap the 'current' link into something. Set `true` in order to convert it to text
						},
					attr: { // Pager tag attributes that can override the defaults
						mode:	'data-jpager-mode', // Overrides `mode`
						paging:	'data-jpager-sets', // This attribute="[[first/]step/]last|current" can override the paging settings
						url:	'data-jpager-url', // Overrides the paging.url
						lang:	'data-jpager-lang' // Overrides the language
						},
					lang: { // Language strings: text || `null` to disable
						"en": {
							prev:	"← Prev",
							next:	"Next →",
							first:	"« First",
							last:	"Last »"
							},
						"ru": {
							prev:	"← Назад",
							next:	"Вперёд →",
							first:	"« Первая",
							last:	"Последняя »"
							}
						}
					}
		);

jQuery.fn.extend({
	/** Create a pager of every node from the matching set
	 * Usage: $(...).jPager3k([<mode>|undefined [, <sets>|undefined [, paging|undefined]]]);
	 * The settings you specify will override those set with $.jPager3k()
	 * @param {?String}		mode		The mode
	 * @param {?Object}		paging		Paging settings
	 * @param {?Object}		sets		Pager settings
	 */
	jPager3k: function(mode, paging, sets){
		this.each(function(){
			var self = jQuery(this);
			// Prevent re-execution
			if (self.data('jPager3k'))
				return;
			self.data('jPager3k', true);
			/* ======[ Prepare the settings ]====== */
			//=== Init the pager resulting settings
			var pager = {
				mode: '',
				paging: {},
				sets: {}
				};
			//=== Settings = {} + Defaults + Arguments
			jQuery.extend(true, pager, jQuery.jPager3k, {
					mode: mode,
					paging: paging,
					sets: sets
					});

			//=== Settings += Attributes
			var attrs = {
				mode: self.attr(pager.sets.attr.mode),
				paging: {
					first: undefined,
					step: undefined,
					last: undefined,
					current: undefined,
					url: self.attr(pager.sets.attr.url),
					lang: self.attr(pager.sets.attr.lang)
					},
				sets: {}
				};
			// Attributes `paging` override
			var attrpaging = /^(\d+)?\/([+-]\d+)?\/(\d+)\|(\d+)$/.exec(self.attr(pager.sets.attr.paging));
			if (attrpaging !== null) {
				if (attrpaging[1] != undefined) attrs.paging.first		= parseInt(attrpaging[1]);
				if (attrpaging[2] != undefined) attrs.paging.step		= parseInt(attrpaging[2]);
				if (attrpaging[3] != undefined) attrs.paging.last		= parseInt(attrpaging[3]);
				if (attrpaging[4] != undefined) attrs.paging.current	= parseInt(attrpaging[4]);
				}
			jQuery.extend(true,pager,attrs);

			/* ======[ Init the pages container & context ]====== */
			var ul = self.find('ul'); // child <ul> for hyperlinks
			// pager
			if (!self.hasClass('jpager3k'))
				self.addClass('jpager3k');
			// ul
			if (ul.length == 0)
				ul = jQuery('<ul></ul>').appendTo(self);
			// hide pager temporary
			self.css('visibility', 'hidden');

			/* ======[ Initialize ul's hyperlinks ]====== */
			switch(pager.mode) {
				case 'manual':
					break;
				case 'auto':
					ul.empty();
					for (var page=pager.paging.first, N=1; (pager.paging.step>0)? page<=pager.paging.last : page>=pager.paging.last; page += pager.paging.step, N++) {
						// Create
						var url = pager.paging.url.replace('%page%', page);
						var tag = jQuery(pager.sets.tags.link.replace('%url%', url).replace('%N%', N)).appendTo(ul);
						// Current?
						if (pager.paging.current == page)
							tag.addClass(pager.sets.tags.current_class);
						}
					break;
				default:
					alert('jPager3k: typo: mode="'+pager.mode+'"');
				}

			/* ======[ The Links ]====== */
			var li = {
				fi: null, // First
				pr: null, // Prev
				cu:	null, // Current
				ne: null, // Next
				la: null // Last
				};
			// The 'current' link
			li.cu = ul.find('.'+pager.sets.tags.current_class);
			if (pager.sets.tags.current_wrap && li.cu.length) {
				li.cu.wrapInner(pager.sets.tags.current_wrap);
				if (pager.sets.tags.current_wrap !== true) // Not only convert but wrap it
					li.cu.text(  li.cu.text()  );
				}

			// The first, prev, next, last links
			li.fi = ul.children(':first');
			li.pr = li.cu.prev();
			li.ne = li.cu.next();
			li.la = ul.children(':last');

			/* ======[ The surroundings ]====== */

			//=== Wrap the <ul>
			ul.wrap('<div class="jpag_ul"></div>');
			var ulwrap = ul.parent();

			//=== Draw the scrollBar & scrollThumb
			var scrollbar = jQuery('<div class="scrollbar"></div>').appendTo(ulwrap);
			var scrollthis = jQuery('<div class="thispage"></div>').appendTo(scrollbar);
			var scrollthumb = jQuery('<div class="scrollthumb"><div></div></div>').appendTo(scrollbar);

			//=== Left & Right Blocks
			// Helper
			var lr_blockgen = function(odiv, className, myli, string){
					if (string !== null) { // The string is not null
						var div = jQuery('<div class="'+className+'">'+string+'</div>').appendTo(odiv);
						if (myli.length && myli[0] != li.cu[0]) // There is a link && != current
							div.wrapInner('<a href="'+myli.find('a').attr('href')+'"></a>');
							else
							div.wrapInner('<span></span>');
						}
					};
			// Create
			var div_l = jQuery('<div class="jpag_l sidelnk"></div>').prependTo(self);
			var div_r = jQuery('<div class="jpag_r sidelnk"></div>').prependTo(self);
			var lang = pager.sets.lang[pager.paging.lang];
			lr_blockgen(div_l, "prevnext",	li.pr, lang.prev);
			lr_blockgen(div_l, "firstlast",	li.fi, lang.first);
			lr_blockgen(div_r, "prevnext",	li.ne, lang.next);
			lr_blockgen(div_r, "firstlast",	li.la, lang.last);

			/* ======[ Events ]====== */
			//=== Store the pages list to scrollThumb
			scrollthumb.data('ul', ul);

			//=== Create the master scroller event
			scrollthumb.bind('_scroll', function(e, x, data){
					//=== Initialize the data upon request
					if (data.dx == undefined) {
						// Objects
						data.thumb = jQuery(this); // ScrollThumb
						data.ul = data.thumb.data('ul'); // <ul>
						data.liws = ul.children().map(function(){  return jQuery(this).position().left;  }); // <li>'s left offset
						data.jdoc = jQuery(document); // document

						var scrollbar = data.thumb.parent();
						// Thumb screen offset & max CSS('left')
						data.dx = scrollbar.offset().left; // ScrollThumb screen offset
						data.len = scrollbar.width() - data.thumb.outerWidth(); // ScrollThumb maximum CSS(left)
						// <ul> max CSS('left')
						data.ul.trigger('_rewidth'); // refresh widths
						data.pgvislen = data.ul.parent().width(); // Length of the visible pager part
						data.pglen = data.ul.width() - data.pgvislen; // Pages maximum CSS(left)
						if (data.pglen<0)
							data.pglen = 0;

						// Hide scrollThumb&thisPage when there're nothing to scroll
						var action = (data.ul.width() <= data.pgvislen)?"hide":"show";
						data.thumb[action]();
						scrollbar.find('.thispage')[action]();
						return;
						}
					//=== Position the thumb
					if (x<0) x=0;
						else if (x>data.len) x = data.len;
					data.thumb.css('left', x+'px');
					//=== Position the pages list
					var left = (x/data.len) * data.pglen; // left = percentage * total length
					// Boundaries
					if (left<0) left=0;
					if (left>data.pglen) left=data.pglen;
					// Navigate
					data.ul.css('left', (-left) + 'px'); // percentage * max_left
					});

			//=== Drag the scrollThumb to navigate to a page
			scrollthumb.mousedown(function(e){
				// Initialize eventData
				var eventData = {};
				jQuery(this).trigger('_scroll', [null, eventData]);

				jQuery(document)
				// Bind mouseMove to the document so you can drag anywhere
					.bind('mousemove', eventData, function(e){
						e.data.thumb.trigger('_scroll', [e.pageX - e.data.dx, e.data]);
						e.preventDefault();
						})
				// Bind once-event mouseUp to the document so you can stop dragging anywhere
					.one('mouseup', eventData, function(e){
						e.data.jdoc.unbind('mousemove');
						e.preventDefault();
						});
				e.preventDefault();
				});

			/* ======[ Finish Her! ]====== */

			//=== Expand <ul>'s width
			// Calculate links width & expand <ul> to it: otherwise it does not want to become wider than the screen :(
			// We do it only in the end because the object could have changed while we were working.
			// We also use outerWidth(true) in order to include borders, padding & margins
			ul.bind('_rewidth', function(){
				var ul = jQuery(this),
					w = 0;
				var lis = ul.children(),
					vislen = ul.parent().width();
				// Measure children
				lis.each(function(){ w += jQuery(this).removeAttr('style').outerWidth(true); });
				// Apply
				ul.width(w < vislen ? vislen : w);
				// Update margins: when there's a small number of pages — scatter them
				if (w < vislen) {
					var marg = (vislen - w) / (lis.length+0.5);
					lis.css('margin-left', marg+'px');
					}
				}).trigger('_rewidth');

			//=== Scroll to the current page
			ul.bind('_scroll2cur', function(){
				var ul = jQuery(this);
				// Show the pager
				self.css('visibility', 'visible');
				// Scroll
				if (li.cu.length) {
					// Initialize eventData
					var eventData = {};
					scrollthumb.trigger('_scroll', [null, eventData]);
					//=== ScrollThumb
					// Determine the required percentage to view the current page in the center
					// X = % * .len = ((li.cu.left - .pgvislen/2)/.pglen) * .len
					var x = ( (li.cu.position().left - eventData.pgvislen/2)/eventData.pglen ) * eventData.len;
					// Navigate
					scrollthumb.trigger('_scroll', [x, eventData]);
					//=== ThisPage marker
					// Width
					var w = (eventData.pgvislen/eventData.ul.width()) * eventData.len;//(1/(ul.children().length)) * eventData.len; // width of ThisPage marker
					w /= 2; // not too wide
					if (w<scrollthumb.width()) w=scrollthumb.width(); // No smaller than the ScrollThumb
					// Center's offset
					var l = -w/2 + x + scrollthumb.width()/2; // left position
					// Boundaries
					if (l<0) l=0;
					if ((l+w)>scrollbar.width()) l = scrollbar.width() - w;
					// Apply
					scrollthis.css({ width: w + 'px', left: l + 'px' });
					}
				});
			// If the page's already loaded — scroll right now! (late pager creation)
			if (jQuery.jPager3k.onLoadRegged)
				ul.trigger('_scroll2cur');
			});

		//=== When the page's fully loaded || tesized — rescroll all pagers
		if (!jQuery.jPager3k.onLoadRegged) {
			jQuery.jPager3k.onLoadRegged = true;
			var rescroll = function(){  jQuery('.jpager3k ul').trigger('_scroll2cur');  };
			jQuery(window).load(rescroll).resize(rescroll);
			}
		return this;
		}
	});


/* ==========[ Init ]========== */
jQuery(function(){
	if (jQuery.jPager3k.sets.init)
		jQuery(jQuery.jPager3k.sets.init).jPager3k();
	});