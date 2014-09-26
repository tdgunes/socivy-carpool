<div class="row form-wrapper">
    <div class="col-lg-4 col-lg-offset-4 col-sm-6 col-sm-offset-3 col-xs-10 col-xs-offset-1">
        <div class="row">

            <div class="col-xs-12 form-messages">
                @foreach ($errors->all() as $error)
                    <p class="bg-warning" style="padding: 10px;">{{{ $error }}}</p>
                @endforeach
            </div>

            <div class="col-xs-12 form-area">
                <div class="row">
                    <div class="col-xs-12 title">
                        <span>{{{ $title }}}</span>
                    </div>
                    <div class="col-xs-12 form-content-area">
                        <form action="{{{ $action }}}" method="post">
                            <div class="row">
                                @yield('auth-form-content')
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>