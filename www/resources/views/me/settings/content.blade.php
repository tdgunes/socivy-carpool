<div class="row">
    <div class="col-md-6 col-md-offset-3 col-xs-12">

        @foreach ($errors->all() as $error)
            <p class="bg-warning" style="padding: 10px;">{{{ $error }}}</p>
        @endforeach

        <form action="{{{ route('me.settings') }}}" method="post" class="form-horizontal">

            <div class="row">
                <div class="col-xs-12 ">
                    <h1 class="page-header">Kişisel Ayarlar</h1>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12 ">
                    <h3>Bilgiler</h3>
                </div>

                <div class="col-xs-12">
                    <div class="form-group">
                        <label for="input-description" class="col-xs-3 control-label">İsim Soyad</label>
                        <div class="col-xs-4">
                            <input name="name" type="text" required class="form-control" value="{{{ $user->name }}}"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="input-description" class="col-xs-3 control-label">Şifre</label>
                        <div class="col-xs-4">
                            <input name="password" type="text" class="form-control"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="input-description" class="col-xs-3 control-label">Email</label>
                        <div class="col-xs-4">
                            <input type="text" readonly class="form-control" value="{{{ $user->email }}}"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="input-description" class="col-xs-3 control-label">Telefon Numarası</label>
                        <div class="col-xs-4">
                            <input name="phone" type="text" required value="{{{ $user->information->phone  }}}" class="form-control"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12">
                    <h3>Oluşturduğum Rotalarda</h3>
                </div>

                <div class="col-xs-12">
                    <div class="form-group">
                        <label for="input-description" class="col-xs-3 control-label">Telefon Numaramı</label>
                        <div class="col-xs-9">
                            <div class="checkbox">
                                <label>
                                    @if($user->routeSettings->show_phone)
                                        <input name="show_phone" type="checkbox" checked> Göster
                                    @else
                                        <input name="show_phone" type="checkbox"> Göster
                                    @endif
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- TODO: Bu özellik daha açılmadı
            <div class="row">
                <div class="col-xs-12">
                    <div class="row">
                        <div class="col-xs-12">
                            <h3>Bildirimler</h3>
                        </div>

                        <div class="col-xs-12">
                            <div class="form-group">
                                <label for="input-description" class="col-xs-3 control-label">Rota Eklendiğinde</label>
                                <div class="col-xs-9">
                                    <div class="checkbox">
                                        <label>
                                            @if($user->routeSettings->mail_when_route_added)
                                                <input name="mail_when_route_added" type="checkbox" checked> Siteye birisi rota eklediğinde mail at.
                                            @else
                                                <input name="mail_when_route_added" type="checkbox"> Siteye birisi rota eklediğinde mail at.
                                            @endif
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            -->

            <div class="btn-group btn-group-justified" style="padding-top: 40px;">
                <div class="btn-group">
                    <button type="submit" class="btn btn-success">Güncelle</button>
                </div>
            </div>

        </form>
    </div>
</div>