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
                        Arabam Yok!
                    </a>
                </li>

                <li>
                    <a href="{{{ route('route.create')  }}}">
                        Rota Oluştur
                    </a>
                </li>

				@yield('metabar-left-list')

			</ul>

			<ul class="nav navbar-nav navbar-right">

				@yield('metabar-right-list')

				@if (Sentry::check() === True)
					<li><a href="{{{ route('auth.logout') }}}">({{{Sentry::getUser()->name}}}) Çıkış</a></li>
				@else
				    <li><a href="{{{ route('auth.login') }}}">Giriş</a></li>
				    <li><a href="{{{ route('auth.register') }}}">Kayıt Ol</a></li>
				@endif
			</ul>
		</div>
	</div>
</div>