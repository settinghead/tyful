/*
** ADOBE SYSTEMS INCORPORATED
** Copyright 2012 Adobe Systems Incorporated
** All Rights Reserved.
**
** NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
** terms of the Adobe license agreement accompanying it.  If you have received this file from a
** source other than Adobe, then your use, modification, or distribution of it requires the prior
** written permission of Adobe.
*/
package com.settinghead.tyful.client
{
  import flash.display.DisplayObjectContainer;
  import sample.pthread.vfs.ISpecialFile;
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.events.Event;
  import sample.pthread.CModule;

  public class pthread_swc extends Sprite implements ISpecialFile
  {
	
	var container:DisplayObjectContainer;
    public function pthread_swc(container:DisplayObjectContainer){
		this.container = container;
      addEventListener(Event.ADDED_TO_STAGE, initCode);
      addEventListener(Event.ENTER_FRAME, enterFrame);
    }
 
    public function initCode(e:Event):void
    {
      CModule.rootSprite =(container)?container:this;

      if(CModule.runningAsWorker()) {
        return;
      }

      CModule.vfs.console = this;
      //CModule.startBackground(this);
      CModule.startAsync(this);
    }

    public function write(fd:int, buf:int, nbyte:int, errno_ptr:int):int
    {
      var str:String = CModule.readString(buf, nbyte);
      trace(str);
      return nbyte;
    }

    public function read(fd:int, buf:int, nbyte:int, errno_ptr:int):int
    {
      return 0;
    }

    public function enterFrame(e:Event):void
    {
	}

		public function fcntl(fileDescriptor : int, cmd : int, data : int, errnoPtr : int) : int {
			return 0;
		}

		public function ioctl(fileDescriptor : int, request : int, data : int, errnoPtr : int) : int {
			return 0;
		}
  }
}
