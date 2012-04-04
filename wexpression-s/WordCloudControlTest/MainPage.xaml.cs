using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using WordCloudControl;
using System.Collections.ObjectModel;

namespace WordCloudControlTest
{
    public partial class MainPage : UserControl
    {
        public MainPage()
        {
            InitializeComponent();
        }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            var l = new ObservableCollection<WordCloud.WordCloudEntry>
{
    new WordCloud.WordCloudEntry() { Word = "Hello", SizeValue = 50, ColorValue=20,Angle = 11},
    new WordCloud.WordCloudEntry() { Word = "World", SizeValue = 45, ColorValue=32,Angle = 18 },
    new WordCloud.WordCloudEntry() { Word = "This is", SizeValue = 42, ColorValue=32,Angle = 14 },
    new WordCloud.WordCloudEntry() { Word = "Mike Talbot's", SizeValue = 47, ColorValue=32,Angle = 21 },
    new WordCloud.WordCloudEntry() { Word = "New", SizeValue = 35, ColorValue=32,Angle = 20 },
    new WordCloud.WordCloudEntry() { Word = "Word Cloud", SizeValue = 65, ColorValue=32,Angle = 15 },
    new WordCloud.WordCloudEntry() { Word = "Component", SizeValue = 35, ColorValue=32,Angle = 17 },
    new WordCloud.WordCloudEntry() { Word = "http://whydoidoit.com", SizeValue = 28, ColorValue=19,Angle = 11 },
    new WordCloud.WordCloudEntry() { Word = "Use it", SizeValue = 16, ColorValue=19,Angle = 16 },
    new WordCloud.WordCloudEntry() { Word = "Free", SizeValue = 53, ColorValue=19,Angle = 16 },
    new WordCloud.WordCloudEntry() { Word = "Create", SizeValue = 23, ColorValue=19,Angle = 11 },
    new WordCloud.WordCloudEntry() { Word = "Wordle", SizeValue = 40, ColorValue=19,Angle = 14 },
    new WordCloud.WordCloudEntry() { Word = "Tag Clouds", SizeValue = 22, ColorValue=19,Angle = 12 },
    new WordCloud.WordCloudEntry() { Word = "www.alterian.com", SizeValue = 15, ColorValue=26,Angle = 18 }
};

            Cloud.Entries = l;

        }
    }
}
