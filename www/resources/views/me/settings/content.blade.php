<div class="row">
    <div class="col-md-6 col-md-offset-3 col-xs-12">
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
                            <input type="text" value="" class="form-control"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="input-description" class="col-xs-3 control-label">Şifre</label>
                        <div class="col-xs-4">
                            <input type="text" value="" class="form-control"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="input-description" class="col-xs-3 control-label">Telefon Numarası</label>
                        <div class="col-xs-4">
                            <input type="text" value="" class="form-control"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-xs-12">
                    <h3 >Oluşturduğum Rotalarda</h3>
                </div>

                <div class="col-xs-12">
                    <div class="form-group">
                        <label for="input-description" class="col-xs-3 control-label">Telefon Numaramı</label>
                        <div class="col-xs-9">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox"> Göster
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

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
                                            <input type="checkbox"> Siteye birisi rota eklediğinde mail at.
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </form>
    </div>
</div>