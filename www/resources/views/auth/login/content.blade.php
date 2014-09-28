@include('auth.form', ['action' => route('auth.authentication'), 'title' => 'Üye Girişi'])

<div class="row">
    <div class="col-lg-3 col-sm-4 col-xs-10 center-block" style="float: none; text-align: center; color: #fefefe;">
        <p>Üye değilsen, <a href="{{{ route('auth.register') }}}" class="link">Kayıt ol</a></p>
    </div>
</div>