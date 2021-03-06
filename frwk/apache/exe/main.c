/*------------------------------------------------------------------
// Copyright (c) 1997 - 2011
// Robert Umbehant
// htmapp@wheresjames.com
// http://www.wheresjames.com
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted for commercial and
// non-commercial purposes, provided that the following
// conditions are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
// * The names of the developers or contributors may not be used to
//   endorse or promote products derived from this software without
//   specific prior written permission.
//
//   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
//   CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
//   INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//   MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
//   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//   NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
//   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
//   EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//----------------------------------------------------------------*/

#define _BLDNAME( a, b ) 	a##b
#define BLDNAME( a, b ) 	_BLDNAME( a, b )

#if defined( __cplusplus )
extern "C" {
#endif

#include <httpd.h>
#include <http_protocol.h>
#include <http_config.h>

#include "frwk.h"
#include "htmapp/import_resources.h"
#include "htmapp_resources.h"

static int mod_handler( request_rec* r )
{
	// Is it for our module?
    if ( !r || !r->handler )
        return DECLINED;

	return process_request( r, CII_PROJECT_NAME );
}
 
int mod_cleanup( void *p )
{
	// Cleanup framework
	uninit_frwk();
	
	return 0;
}
 
static void register_hooks( apr_pool_t* pool )
{
	// Initialize resources
	HTMAPP_INIT_RESOURCES();

	// Initialize framework
	init_frwk();

	// Register cleanup function
	apr_pool_cleanup_register( pool, 0, mod_cleanup, 0 );
	
	// Add our handler
    ap_hook_handler( mod_handler, 0, 0, APR_HOOK_MIDDLE );
}

static const command_rec mod_cmds[] =
{
    { 0 }
};

module AP_MODULE_DECLARE_DATA BLDNAME( CII_PROJECT, _module ) = 
{
    STANDARD20_MODULE_STUFF,
    0,
    0,
    0,
    0,
    mod_cmds,
    register_hooks
};

#if defined( __cplusplus )
};
#endif
