<div class="row">

    <div class="col-lg-4 col-lg-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1">
    	@foreach ($errors->all() as $error)
    		<p class="bg-warning" style="padding: 10px;">{{{ $error }}}</p>
    	@endforeach
    </div>

    <div class="col-lg-4 col-lg-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1 login-area">
        <form action="{{{ route('auth.authentication') }}}" method="post">
            <div class="row">

                <div class="col-xs-12 email-area">
                    <input type="text" name="email" placeholder="name@ozu.edu.tr"/>
                </div>

                <div class="col-xs-12 password-area">
                    <input type="password" name="password" placeholder="password"/>
                </div>

                <div class="col-xs-12 submit-area">
                    <button type="submit" class="btn btn-primary pull-right">Giriş</button>
                </div>
            </div>
        </form>
    </div>
</div>