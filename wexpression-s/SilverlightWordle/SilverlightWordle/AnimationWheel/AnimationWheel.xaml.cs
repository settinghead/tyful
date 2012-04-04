using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace SilverlightWordle
{
  public partial class AnimationWheel : UserControl
  {
    public AnimationWheel()
    {
      // Required to initialize variables
      InitializeComponent();
      beginAnimation();
    }

    void beginAnimation()
    {
      AnimationChainManager am = new AnimationChainManager(false);

      int delay = 0;

      foreach (UIElement child in SpinWheel.Children)
      {
        am.Add()
            .DoubleAnimationK() // Create a new Double animation with keyframes
            .Target(child) // Target the UIElement
            .Property(Path.OpacityProperty) // Change the opacity of the object.
            .KeyFrame(1, new TimeSpan(0))// At time 0, have opacity of 100%
            .KeyFrame(.3, new TimeSpan(0, 0, 0, 1, 0)) // Move to 30% at 1 second
            .KeyFrame(.3, new TimeSpan(0, 0, 0, 0, 700)) // Wait 700 ms before repeating (this is how long it takes to get back around
            .Repeat() // Keep doing it forever
            .Offset(new TimeSpan(0, 0, 0, 0, delay))
            .Queue();

        delay += 100; // wait 100ms in between each animation, so they start slightly after each other (create the wheel effect)
      }

      am.Begin(false, false);
    }
  }
}