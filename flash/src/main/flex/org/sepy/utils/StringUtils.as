package org.sepy.utils
{
	public class StringUtils
	{
		
		/**
		 * Fill the passed string of n chars to the right with the passed c char
		 * 
		 * @param s Source string 
		 * @param c char to be used as fill char
		 * @param fillCount lenght of the string to be returned
		 */
		public static function fillRight(s:String, c:String, fillCount:uint):String
		{
			while(s.length < fillCount){
				s += c.substr(0,1);
			}
			return s;
		}
		
		public static function fillLeft(s:String, c:String, fillCount:uint):String
		{
			while(s.length < fillCount){
				s = c.substr(0,1) + s;
			}
			return s;
		}
	}
}