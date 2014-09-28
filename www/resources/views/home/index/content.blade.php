
<div class="row">
    <div class="col-xs-10 col-xs-offset-1 col-md-6 col-md-offset-3">
        <p class="main-title">
            @Lang('site.title')
        </p>
        <p class="main-text">
            Özyeğin Üniversitesi araç paylaşım ağı!
        </p>
        @if(!Sentry::check())
            <p class="login-text">
                Üye olmak için <a class="link" href="{{{ route('auth.register') }}}">Kayıt</a>
            </p>
            <p class="login-text">
                Üyeler için <a class="link" href="{{{ route('auth.login') }}}">Giriş</a>
            </p>
        @endif
    </div>
</div>