<!--METABAR-->
<div id="metabar" class="navbar navbar-default navbar-fixed-top" role="navigation">
	<div class="container-fluid">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>

            <a class="navbar-brand" href="{{{ route('home') }}}">
                <span>
                    @Lang('site.title')
                </span>
            </a>

		</div>
		<div class="navbar-collapse collapse">
			<ul class="nav navbar-nav">

				<li>
                    <a href="{{{ route('route.index')  }}}">
                        <i class="fa fa-thumbs-up"></i> Arabam Yok
                    </a>
                </li>

                <li>
                    <a href="{{{ route('route.create')  }}}">
                        <i class="fa fa-car"></i> Arabam Var
                    </a>
                </li>

				@yield('metabar-left-list')

			</ul>

			<ul class="nav navbar-nav navbar-right">

				@yield('metabar-right-list')

				@if (Sentry::check() === True)
					<li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">{{{Sentry::getUser()->name}}}<span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="{{{ route('me.settings') }}}">Ayarlar</a></li>
                            <li class="divider"></li>
                            <li><a href="{{{ route('auth.logout') }}}">Çıkış</a></li>
                        </ul>
                    </li>
				@else
				    <li><a href="{{{ route('auth.login') }}}">Giriş</a></li>
				    <li><a href="{{{ route('auth.register') }}}">Kayıt Ol</a></li>
				@endif
			</ul>
		</div>
	</div>
</div>