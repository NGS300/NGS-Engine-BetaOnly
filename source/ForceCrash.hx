package;

import openfl.system.System;
/*#if windows
import Sys;
import sys.FileSystem;
#end*/
using StringTools;

class ForceCrash extends MusicBeatSubstate{
    override public function create(){
        System.exit(0);
    }
}