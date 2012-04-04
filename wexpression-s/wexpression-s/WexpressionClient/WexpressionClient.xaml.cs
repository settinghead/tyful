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

namespace com.settinghead.wexpression.client
{
    public partial class WexpressionClient : UserControl
    {
        private ApplicationFacade Facade;

        public WexpressionClient()
        {
            InitializeComponent();

            Facade = ApplicationFacade.getInstance() as ApplicationFacade;
            Facade.Startup(this);
        }
    }
}
