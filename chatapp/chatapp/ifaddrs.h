<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>ifaddrs.h</title>
<style type="text/css">
.enscript-comment { font-style: italic; color: rgb(178,34,34); }
.enscript-function-name { font-weight: bold; color: rgb(0,0,255); }
.enscript-variable-name { font-weight: bold; color: rgb(184,134,11); }
.enscript-keyword { font-weight: bold; color: rgb(160,32,240); }
.enscript-reference { font-weight: bold; color: rgb(95,158,160); }
.enscript-string { font-weight: bold; color: rgb(188,143,143); }
.enscript-builtin { font-weight: bold; color: rgb(218,112,214); }
.enscript-type { font-weight: bold; color: rgb(34,139,34); }
.enscript-highlight { text-decoration: underline; color: 0; }
</style>
</head>
<body id="top">
<h1 style="margin:8px;" id="f1">ifaddrs.h&nbsp;&nbsp;&nbsp;<span style="font-weight: normal; font-size: 0.5em;">[<a href="http://www.opensource.apple.com/source/Libinfo/Libinfo-406.17/gen.subproj/ifaddrs.h?txt">plain text</a>]</span></h1>
<hr>
<div></div>
<pre><span class="enscript-comment">/*	$FreeBSD: src/include/ifaddrs.h,v 1.3.32.1.4.1 2010/06/14 02:09:06 kensmith Exp $	*/</span>

<span class="enscript-comment">/*
 * Copyright (c) 1995, 1999
 *	Berkeley Software Design, Inc.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY Berkeley Software Design, Inc. ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL Berkeley Software Design, Inc. BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	BSDI ifaddrs.h,v 2.5 2000/02/23 14:51:59 dab Exp
 */</span>

#<span class="enscript-reference">ifndef</span>	<span class="enscript-variable-name">_IFADDRS_H_</span>
#<span class="enscript-reference">define</span>	<span class="enscript-variable-name">_IFADDRS_H_</span>

#<span class="enscript-reference">include</span> <span class="enscript-string">&lt;Availability.h&gt;</span>

<span class="enscript-type">struct</span> ifaddrs {
	<span class="enscript-type">struct</span> ifaddrs  *ifa_next;
	<span class="enscript-type">char</span>		*ifa_name;
	<span class="enscript-type">unsigned</span> <span class="enscript-type">int</span>	 ifa_flags;
	<span class="enscript-type">struct</span> sockaddr	*ifa_addr;
	<span class="enscript-type">struct</span> sockaddr	*ifa_netmask;
	<span class="enscript-type">struct</span> sockaddr	*ifa_dstaddr;
	<span class="enscript-type">void</span>		*ifa_data;
};

<span class="enscript-comment">/*
 * This may have been defined in &lt;net/if.h&gt;.  Note that if &lt;net/if.h&gt; is
 * to be included it must be included before this header file.
 */</span>
#<span class="enscript-reference">ifndef</span>	<span class="enscript-variable-name">ifa_broadaddr</span>
#<span class="enscript-reference">define</span>	<span class="enscript-variable-name">ifa_broadaddr</span>	ifa_dstaddr	<span class="enscript-comment">/* broadcast address interface */</span>
#<span class="enscript-reference">endif</span>

<span class="enscript-type">struct</span> ifmaddrs {
	<span class="enscript-type">struct</span> ifmaddrs	*ifma_next;
	<span class="enscript-type">struct</span> sockaddr	*ifma_name;
	<span class="enscript-type">struct</span> sockaddr	*ifma_addr;
	<span class="enscript-type">struct</span> sockaddr	*ifma_lladdr;
};

#<span class="enscript-reference">include</span> <span class="enscript-string">&lt;sys/cdefs.h&gt;</span>

__BEGIN_DECLS
<span class="enscript-type">extern</span> <span class="enscript-type">int</span> <span class="enscript-function-name">getifaddrs</span>(<span class="enscript-type">struct</span> ifaddrs **);
<span class="enscript-type">extern</span> <span class="enscript-type">void</span> <span class="enscript-function-name">freeifaddrs</span>(<span class="enscript-type">struct</span> ifaddrs *);
<span class="enscript-type">extern</span> <span class="enscript-type">int</span> <span class="enscript-function-name">getifmaddrs</span>(<span class="enscript-type">struct</span> ifmaddrs **) __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_4_3);
<span class="enscript-type">extern</span> <span class="enscript-type">void</span> <span class="enscript-function-name">freeifmaddrs</span>(<span class="enscript-type">struct</span> ifmaddrs *) __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_4_3);
__END_DECLS

#<span class="enscript-reference">endif</span>
</pre>
<hr>
</body></html>